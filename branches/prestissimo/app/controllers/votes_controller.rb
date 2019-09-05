class VotesController < ApplicationController

  before_filter :assign_vars
  before_filter :correct_user

  def create
    if params[:value] == 'up'
      @comment.upvote_from @handle
    elsif params[:value] == 'down'
      @comment.downvote_from @handle
    else
      # this should not occur
    end
    @comment
  end

  def destroy
    res = @comment.unliked_by voter: @handle
    logger.debug res
    @comment
  end

  private

  def assign_vars
    @comment = Comment.find(params[:comment_id])
    @handle = Handle.find(params[:handle_id])
  end

  def correct_user
    redirect_to comments_path(@comment.commentable_type, @comment.commentable_id, @comment.id) unless current_user.handlekey == @handle.handlekey
  end
end
