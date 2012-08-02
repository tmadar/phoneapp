class UsersController < ApplicationController
 
  def index
    @users = User.all
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @user = User.find(params[:id])
    respond_to do |format|
        format.html
    end
  end
  
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      @user.update_attributes(params[:user])
        format.html { redirect_to users_path()}
    end
  end
    
end
