class Auditor::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def show
  	@issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
  end

  def index
  	@issues = Issue.paginate(page: params[:page], per_page: 5)
    @issues_new = Issue.where("status_id = 1").paginate(page: params[:page], per_page: 5)
     #change to what Status/es for Issues Auditors need to see
  end

  private

  def auditor_user
      redirect_to(root_path) unless current_user.type_id==5
  end
end
