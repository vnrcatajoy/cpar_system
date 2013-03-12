class Admin::UsersController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    #change code later so Admin will still need to approve User registration
    if @user.save
      flash[:success] = "Successfully added new User: #{@user.name}!" 
      redirect_to admin_user_path(@user)
    else
      render 'new'
    end
  end

  def index
  	@users = User.paginate(page: params[:page],  per_page: 10)
  end

  def edit
  	@user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile for #{@user.name} updated"
      redirect_to admin_user_path
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to admin_users_path
  end

  private

  def admin_user
      redirect_to(root_path) unless current_user.admin?
  end
end
