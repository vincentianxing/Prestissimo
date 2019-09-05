class CommentsController < ApplicationController

  before_filter :load_commentable
  before_filter :load_handle
  before_filter :student_user, only: [:edit, :reply, :create, :reply_form, :update]
  before_filter :mute_handle, only: [:edit, :reply, :reply_form, :create, :update]
  
  def create
    if !params[:comment][:body].blank?
      @comment = Comment.build_from( @commentable, @handle.id, params[:comment][:body])
      logger.debug @comment.inspect
      if @comment.save
        # goto index
        redirect_to comments_path(@comment.commentable_type.underscore, @comment.commentable_id)
      else
        flash.now[:failure] = "Error making comment"
      end
    else
	    @message = "Cannot post an empty comment"
	    respond_to do |format|
		    format.js
		    format.html
	    end
    end
  end

  def index
    all_comments = @commentable.root_comments
    # remove all old and hidden comments
    @comments = Array.new
    all_comments.each do |c|
	    @comments << c unless c.status == "removed" || c.old
    end
    @comments = Comment.sort_by_score(@comments)
    logger.debug @comments
    @comments
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.has_children? || (@comment.created_at + 5.minutes).past?
      @comment.status = "hidden"
      if @comment.save
        @message = "Couldn't delete comment. Content has been hidden."
      else
        @message = "Something went wrong"
      end
    else
      if @comment.destroy
        @message = 'Comment deleted'
      else
        @message = 'Something went wrong'
      end
    end
    # render js that removes comment from page
    @message
  end
  
  def new
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    # create a new comment to hold the old comment
    @comment_old = Comment.build_from( @commentable, @comment.user_id, @comment.body )
    # need to make the old comment not display on page
    @comment_old.set_prev(@comment.prev)
    @comment_old.make_old
    @comment_old.parent_id = @comment.parent_id
    if @comment_old.save
      # the new (old) comment should have the new content and refer to the old version
      @comment.edit(params[:comment][:body], @comment_old.id)
      if @comment.save
        # everything worked
	      if @comment.upvotes.size > 0
		      @comment.upvotes.each do |v|
			      @comment_old.upvote_from Handle.find(v.voter_id)
		      end
	      end
	      if @comment.downvotes.size > 0
		      @comment.downvotes.each do |v|
			      @comment_old.downvote_from Handle.find(v.voter_id)
		      end
	      end
      else
        # new comment doesn't refer to this, so trash it
        @comment_old.delete
      end
    else
      # something went wrong
    end
    @comment
  end

  # shows the previous version of the comment
  def show
    new = Comment.find(params[:id])
    @comment = Comment.find(new.prev)
    @comment.div_id = new.id
  end

  def reply_form
    @comment = Comment.find(params[:id])
  end

  def reply
	  if !params[:comment][:body].blank?
		  parent = Comment.find(params[:id])
            @comment = Comment.build_from( @commentable, @handle.id, params[:comment][:body] )
            @comment.save
		  @comment.move_to_child_of(parent)
		  if @comment.save
			  redirect_to comments_path(@comment.commentable_type.underscore, @comment.commentable_id)
		  else
			  flash.now[:failure] = "Error making reply"
		  end
	  else
		  @message = "Cannot post an empty comment"
		  respond_to do |format|
			  format.js
			  format.html
		  end
	  end
  end

  def hide_remove
	  @comment = Comment.find(params[:id])
	  @comment.toggle_status(params[:status])
	  params[:status] 
	  @comment.save
  end

  private

  def load_handle
    @handle ||= Handle.find_by_handlekey(current_user.handlekey)
  end
  
  def load_commentable
    @commentable = params[:commentable_type].camelize.constantize.find(params[:commentable_id])
  end

  def student_user
	  redirect_to sign_in_path unless current_user.role == "Student"
  end

  def mute_handle
	  redirect_to :back if @handle.is_mute
  end
end
