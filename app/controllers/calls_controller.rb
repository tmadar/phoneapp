class CallsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @calls = Call.paginate page: params[:page], order: 'created_at desc', per_page: 10
    @users = User.where("name is not null")
    respond_to do |format|
      format.html
      format.xml { render 'index.xml.builder' }
    end
  end
  
  def show
    @call = Call.where(:id => params[:id]).first
    respond_to do |format|
      format.html
      format.xml { render :xml => @call }
      format.json { render :json => @call }
      format.js
    end
  end
  
  # PUT /calls/1
  # PUT /calls/1.json
  def update
    @call = Call.find(params[:id])
    @call.update_attributes(params[:call])
    respond_to do |format|
        format.html
        format.json { render :json => @call }
        format.js
    end
  end
  
  def in_progress
    @calls = Call.in_progress
    respond_to do |format|
      format.json { render :json => @calls }
      format.xml { render :xml => @calls }
      format.js
    end
  end
    
end
