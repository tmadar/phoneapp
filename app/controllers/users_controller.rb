class UsersController < ApplicationController
  load_and_authorize_resource
 
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.js
      format.json  { render :json => @users }
    end
  end
  
  def edit
    @user = User.find(params[:id])
    respond_to do |format|
        format.html
        format.js
    end
  end
  
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # PUT /calls/1
  # PUT /calls/1.json
  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    respond_to do |format|
        format.html
        format.js
        format.json  { render :json => @users }
    end
  end
    
end
