class Comment < ActiveRecord::Base
  # attr_accessible :title, :body
  
  attr_accessible :body, :name
  belongs_to :call
  
  def index
    @comments = Comment.all
    respond_to do |format|
      format.html
    end
  end
  
  
  
end
