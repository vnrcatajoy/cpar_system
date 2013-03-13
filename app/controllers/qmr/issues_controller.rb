class Qmr::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :qmr_user

  def index
     @issues = Issue.paginate(page: params[:page], per_page: 3)
     @issues_new = Issue.where("status_id = 1").paginate(page: params[:page], per_page: 2)
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new params[:issue]

    if @issue.save
      redirect_to qmr_issues_path, notice: 'The issue has been created!'
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
      redirect_to qmr_issue_path, :notice => 'The issue has been updated successfuly!'  
    else
      redirect_to :back, :notice => 'There was an error in updating your issue.'
    end
  end

  def destroy
    Issue.destroy params[:id]
    redirect_to qmr_issues_path, :notice => 'The issue was successfuly deleted.'
  end

  private

  def qmr_user
      redirect_to(root_path) unless current_user.type_id==4
  end
end
