class CommentsController < ApplicationController
  
  def create
    @comment = Comment.new(params[:comment])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to records_path()}
      end
    end
  end

    def destroy
      @record = Record.find(params[:record_id])
      @comment = @record.comments.find(params[:id])
      @comment.destroy
    end
  
    def new
      @comment = Comment.new

      respond_to do |format|
        format.html  # new.html.erb
        format.json  { render :json => @comment }
      end
    end
    
end
