class UsersController < ApplicationController
  load_and_authorize_resource
 
 #Gives list of all the current agent in the system
  def index
    @users = User.order(:priority)
    respond_to do |format|
      format.html { render :layout => "#{@empty ? "empty" : "application"}"}
      format.js
      format.json  { render :json => @users }
    end
  end
  
  #Modal to editing info about the agent
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def search
    @users = User.where("lcase(name) like ?", "%#{params[:term].downcase}%")
    respond_to do |format|
      format.html
      format.js
      format.json  { render :json => @users.map { |user| user.name } }
    end
  end
  
  
  #puts any changes to the agent into affect
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    respond_to do |format|
        format.html
        format.js
        format.json  { render :json => @users }
    end
  end
  
  def sync_with_zendesk
    UserSyncr.sync_with_zendesk
    @users = User.all
    respond_to do |format|
      format.html { redirect_to users_path }
      format.js
      format.json  { render :json => @users }
    end
  end

  def prioritize
    User.prioritize(params)
    @users = User.all
    respond_to do |format|
      format.html { redirect_to users_path }
      format.js
      format.json  { render :json => @users }
    end
  end
    
end
