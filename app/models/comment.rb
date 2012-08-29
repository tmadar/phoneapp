class Comment < ActiveRecord::Base
  # attr_accessible :title, :body
  
  attr_accessible :body, :name
  belongs_to :call
  belongs_to :user
  after_save :update_last_comment
  after_save :comment_on_zendesk
  
  #When a comment is made on a call, the last comment attribute of the
  #call will be updated
  def update_last_comment
    if self.call
      self.call.update_attribute(:last_comment, self.body)
    end
  end
  
  def comment_on_zendesk
    if self.call
      self.call.zendesk_ticket.comments << self.call.comments
    end
  end
  
end
