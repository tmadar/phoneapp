class CallsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :setup_users, :except => [ :in_progress ]
  
  def setup_users
    @users = User.all
  end
  
  #shows the comprehensive list of calls
  def index
    @calls = Call.paginate page: params[:page], order: 'created_at desc', per_page: 10
    respond_to do |format|
      format.html { render :layout => "#{params[:empty] ? "empty" : "application"}"}
      format.js
      format.xml { render 'index.xml.builder' }
    end
  end
  
  def unresolved
    @calls = Call.where(:disposition => "Open", :status => "completed", :user_id => nil).paginate page: params[:page], order: 'created_at desc', per_page: 5
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  #Modal view of specific info of the call
  #giving reschedule time, comments, etc.
  def show
    @call = Call.where(:id => params[:id]).first
    respond_to do |format|
      format.html
      format.xml { render :xml => @call }
      format.json { render :json => @call }
      format.js
    end
  end

  #Allows for the action of assigning agents to the call, etc.
  def update
    @call = Call.find(params[:id])
    @call.update_attributes(params[:call])
    respond_to do |format|
        format.html
        format.json { render :json => @call.to_json(:include => [ :user ]) }
        format.js
    end
  end
  
  #If a call by a customer is "ringing" or "in-progress", it will
  #be shown on the Home page in AJAX
  def in_progress
    @calls = Call.in_progress
    respond_to do |format|
      format.json { render :json => @calls }
      format.xml { render :xml => @calls }
      format.js
    end
  end
    
end
