class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    #change code later so Admin will still need to approve User registration
    if @user.save
      sign_in @user
      flash[:success] = "Registration Success!" 
      redirect_to @user
    else
      render 'new'
    end
  end
end
