class IssuesController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show, :new, :edit, :update]
  #before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user,     only: [:destroy]

  def index
    # still needs to be revised further
    if current_user.type_id == 1  #super admin
      @issues = Issue.paginate(page: params[:page], per_page: 10)
    else  #get issues reported to you or your department
      @issues = Issue.where("department_id = " + current_user.department_id.to_s + " OR user_id = " + current_user.id.to_s).paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    @issue = Issue.new
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
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
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

end
