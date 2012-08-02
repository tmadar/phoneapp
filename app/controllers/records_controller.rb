class RecordsController < ApplicationController
  
  def index
    @call_record = Call.find(params[:id]) 
#    @comment = @call_record.comments.create(params[:comment])
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def update
    @call_record = Call.find(params[:id])
    @comment = @call_record.comment.create(params[:comment])
    respond_to do |format|
      @call.update_attributes(params[:comment])
        format.html { redirect_to users_path()}
    end
  end
  
  def create
    @call_record = Call.find(params[:id]) 
    @comment = @call_record.comments.build(params[:comment])
    respond_to do |format|
      format.html
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
