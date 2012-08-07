class RecordsController < ApplicationController
  
  def index
    @call_record = Call.find(params[:id])
    @comment = Comment.new
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
end
