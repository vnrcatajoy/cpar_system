class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :show]
  before_filter :correct_user,   only: [:edit, :update]

  def new
  	@user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_verification_email
      flash[:success] = "Registration Success! Please verify your email using the instructions sent to your email." 
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    @users = User.where("department_id = " + current_user.department_id.to_s).paginate(page: params[:page],  per_page: 15)
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

end
