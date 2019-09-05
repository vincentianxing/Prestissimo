# == Schema Information
#
# Table name: comments
#
#  id                 :integer(4)      not null, primary key
#  commentable_id     :integer(4)      default(0)
#  commentable_type   :string(255)     default("")
#  title              :string(255)     default("")
#  body               :text
#  subject            :string(255)     default("")
#  user_id            :integer(4)      default(0), not null
#  parent_id          :integer(4)
#  lft                :integer(4)
#  rgt                :integer(4)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  status             :string(255)     default("active")
#  prev               :integer(4)
#  cached_votes_total :integer(4)      default(0)
#  cached_votes_up    :integer(4)      default(0)
#  cached_votes_down  :integer(4)      default(0)
#  old                :boolean(1)      default(FALSE)
#

class Comment < ActiveRecord::Base
	attr_accessor :div_id

	# Means that a comment can be reported by other users
	# To view, comment.reports
	has_many :reports, as: :reportable

  # Permits the threading of comments based on their id and type.
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  # If a record has a nil value for one of these attributes, attempting to save
  # it will fail and return false.
  validates_presence_of :body, :user_id, :commentable_id, :commentable_type



  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # we're using votable instead of voteable (it seems more thorough)
  acts_as_votable


  # Allows us to associate comments with multiple other models
  belongs_to :commentable, :polymorphic => true

  # Comments belong to a handle
  belongs_to :handle

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  def self.build_from(obj, user_id, comment)
    c = self.new
    c.commentable_id = obj.id
    c.commentable_type = obj.class.base_class.name
    c.body = comment
    c.user_id = user_id
    c
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.size > 0
  end

  #method to get the username of the commentor
  def handle
    handle = Handle.find(self.user_id).username
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  # 'Scope' means this method is associated with a database query.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  # used by the update method to update the body and prev version id of a comment
  def edit(new_body, prev_id)
    self.body = new_body
    self.prev = prev_id
  end

  # set the prev version id of a comment
  def set_prev(prev_id)
    self.prev = prev_id
  end

  def toggle_status(status)
	  if self.status == status
		  self.status = "active"  
	  else
		  self.status = status
	  end
  end

  # calculate the voted score of the comment
  def score
    score = self.upvotes.size - (1.25 * self.downvotes.size)
  end

  def make_old
    self.old = true
  end
  
  def self.sort_by_score(comments)
	  sorted = Array.new
	  last_date_index = 0
	  last_index = 0
	  high_score = Setting.get_val("high_comment_score").to_i
	  comments.each do |c|
		  # if the score is high, put it at the front before next highest
		  if c.score > high_score 
			  counter = 0 
			  top_score = sorted(counter).score 
			  while c.score < top_score
				 counter += 1 
				 top_score = sorted(counter).score
			  end
			  sorted.insert(counter,c)
			  last_index += 1
			  last_date_index += 1
		  # if it was made in the last 3 days, put it after the high scores, chronologically
		  elsif c.created_at > DateTime.now - 3.days
			  sorted.insert(last_date_index,c)
			  last_index += 1
	  	  # all other comments go at the end sorted by score
		  else
			  counter = 0
			  score = c.score
			  if sorted[last_index]
				  other_score = sorted[last_index].score
				  while score < other_score
					  counter += 1
					  if sorted[last_index+counter]
						  other_score = sorted[last_index+counter].score
					  else
						  break
					  end
				  end
			  end
			  sorted.insert(last_index+counter,c)
		  end
	  end
	  sorted
  end
end
