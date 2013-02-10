class IssuesController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show, :new, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: [:destroy]

  def index
    if current_user.admin?
      @issues = Issue.paginate(page: params[:page], per_page: 10)
    else
      @issues = Issue.paginate(page: params[:page], per_page: 10)
      #TODO: limit visible issues to user type scope
    end
  end

  def new
    @issue = Issue.new user_id: current_user.id
  end

  def create
    @issue = Issue.new params[:issue]

    if @issue.save
      redirect_to issues_path, notice: 'The issue has been created!'
    else
      redirect_to :back, notice: 'There was an error in creating your issue.'
    end
  end

  def show
    @issue = Issue.find params[:id]
  end

  def edit
    @issue = Issue.find params[:id]
  end

  def update
    issue = Issue.find params[:id]

    if issue.update_attributes params[:issue]
      redirect_to issues_path, :notice => 'The issue has been updated successfuly!'  
    else
      redirect_to :back, :notice => 'There was an error in updating your issue.'
    end
  end

  def destroy
    Issue.destroy params[:id]
    redirect_to :back, :notice => 'The issue was successfuly deleted.'
  end

  def admin_user
      redirect_to(root_path) unless current_user.admin?
  end
end
