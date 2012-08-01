class UsersController < ApplicationController
 
  def index
    @users = User.all
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @users = User.all
    respond_to do |format|
      format.html
    end
  end

  def dashboard
  end
end
