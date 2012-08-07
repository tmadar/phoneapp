class UsersController < ApplicationController
 
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
    end
  end
  
  def show
    @user = User.where(:id => params[:id]).first
    respond_to do |format|
      format.html {redirect_to users_url}
      # format.xml { render :xml => @user }
      # format.json { render :json => @user }
    end
  end
  
  # PUT /calls/1
  # PUT /calls/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
    
end
