class Admin::UsersController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_verification_email
      flash[:success] = "Successfully added new User: #{@user.name}! 
        Please ask User to verify his or her email account next from their email." 
      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  def index
    if params[:sort] != nil
      if params[:sort] == '1'
        @users = User.where(verified: 't', account_enabled: 'f').paginate(page: params[:page], per_page: 10)
      else 
        @users = User.where("type_id = "+ params[:sort]).paginate(page: params[:page], per_page: 10)
      end
    else
  	  @users = User.paginate(page: params[:page],  per_page: 10)
    end
  end

  def activate
    @user = User.find(params[:id])
    @user.account_enabled = true
    if @user.save
      UserMailer.welcome_email(@user).deliver
      flash[:success] = "Successfully activated this User's account and sent Welcome Email."
      redirect_to admin_users_path
    end
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
