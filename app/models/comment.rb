class Comment < ActiveRecord::Base
  # attr_accessible :title, :body
  
  attr_accessible :body, :name
  belongs_to :call
  after_save :update_last_comment
  
  def index
    @comments = Comment.all
    respond_to do |format|
      format.html
    end
  end
  
  def update_last_comment
    if self.call
      self.call.update_attribute(:last_comment, self.body)
    end
  end
  
end
