class RecordsController < ApplicationController
  
  def index
    @call_record = Call.find(params[:id])
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # def new
  #   @call = Call.find(params[:id])
  #   @comment = @call.comments.create(params[:comment])
  #   respond_to do |format|
  #     if @comment.save
  #       format.html { redirect_to }
  #     end
  #   end
  # end
  # 
  # def edit
  #   @record = Record.find(params[:id])
  # end
  # 
  # def create
  #   @call = Call.find(params[:id])
  #   @comment = @call.comments.create(params[:comment])
  #   respond_to do |format|
  #     if @comment.save
  #       format.html { redirect_to home_index_path()}
  #     end
  #   end
  # end
  
end
