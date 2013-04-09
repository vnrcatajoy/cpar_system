class Auditor::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def show
  	@issue = Issue.find params[:id]
    # moved Causes and ActionPlans to details view
    @action_plans_implemented = ActionPlan.where(issue_id: @issue.id, ap_status_id: 5)
    @closeoutforms= CloseoutForm.where(issue_id: @issue.id)
    @closeoutform = CloseoutForm.new
    #@cof = CloseoutForm.find_by_issue_id(@issue.id) #should be in details
    @issue_comment = IssueComment.new
    @issuecomments = @issue.issue_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @issueupdates = @issue.issue_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  def index
  	if params[:sort] != nil
      @issues = Issue.where("status_id = " + params[:sort]).paginate(page: params[:page], per_page: 10)
    else
     @issues = Issue.paginate(page: params[:page], per_page: 10)
    end
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    @cof = CloseoutForm.find_by_issue_id(@issue.id)
  end

  private

  def auditor_user
      redirect_to(root_path) unless current_user.type_id==5
  end
  # Check for uniqueness later of Dept_id inside one COF before generating
end
