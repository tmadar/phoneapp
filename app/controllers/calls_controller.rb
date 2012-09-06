class CallsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :setup_users, :except => [ :in_progress ]
  
  def setup_users
    @users = User.all
  end
  
  #shows the comprehensive list of calls
  def index
    @calls = Call.rsend(*sort_order_for_calls).paginate page: params[:page], per_page: 10
    respond_to do |format|
      format.html { render :layout => "#{@empty ? "empty" : "application"}"}
      format.js
      format.xml { render 'index.xml.builder' }
      format.json
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
  
  def sort_order_for_calls
    if Call.column_names.include?(params[:sort_by])
      if params[:sort_by] == "caller"
        return [[:order, "replace(replace(replace(#{params[:sort_by]}, '-', ''), '+1', ''), '+', '') #{params[:direction] == "1" ? "asc" : "desc"}"]]
      elsif params[:sort_by] == "user_id"
        return [[:joins, "LEFT OUTER JOIN users on calls.user_id = users.id"], [:order, "users.name #{params[:direction] == "1" ? "asc" : "desc"}"]]
      else
        return [[:order, "#{params[:sort_by]} #{params[:direction] == "1" ? "asc" : "desc"}"]]
      end
    else
      return [[:order, "created_at desc"]]
    end
  end
  
    
end
