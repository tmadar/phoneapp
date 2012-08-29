class CommentsController < ApplicationController
  
  #Allows an agent to add additional comments to a call
  #in "View Call Info" in either the Home page or Call Archive
  def create
    @call = Call.find(params[:call_id])
    @comment = @call.comments.create(params[:comment])
    @comment.user = self.current_user
    respond_to do |format|
      format.html { redirect_to call_path(@call) }
      format.js
    end
  end

  # def destroy
  #   @call = Call.find(params[:call_id])
  #   @comment = @call.comments.find(params[:id])
  #   @comment.destroy
  # end

  # def new
  #   @comment = Comment.new
  # 
  #   respond_to do |format|
  #     format.html  # new.html.erb
  #     format.json  { render :json => @comment }
  #   end
  # end
  
  def update
    @call_record = Call.find(params[:id])
    @call_record.update_attributes(params[:comment])
    
    respond_to do |format|
      format.html
    end
  end
    
end
