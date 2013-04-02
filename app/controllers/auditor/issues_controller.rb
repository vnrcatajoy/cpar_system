class Auditor::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def show
  	@issue = Issue.find params[:id]
    # moved Causes and ActionPlans to details view
    @action_plans = ActionPlan.where(issue_id: @issue.id, implemented: 't')
    @closeoutforms= CloseoutForm.where(issue_id: @issue.id)
    @closeoutform = CloseoutForm.new
    #@cof = CloseoutForm.find_by_issue_id(@issue.id) #should be in details
  end

  def index
  	@issues = Issue.paginate(page: params[:page], per_page: 5)
    @issues_correcting = Issue.where("status_id = 4").paginate(page: params[:page], per_page: 5)
     #change to what Status/es for Issues Auditors need to see
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    @cof = CloseoutForm.find_by_issue_id(@issue.id)
    if @cof.closeout_form_depts.empty?
      generate_closeoutform_depts
    end
  end

  private

  def auditor_user
      redirect_to(root_path) unless current_user.type_id==5
  end

  def generate_closeoutform_depts
    issue = Issue.find params[:id]
    cof= CloseoutForm.find_by_issue_id(@issue.id)
    @cof_dept = cof.closeout_form_depts.build({dept_id: issue.department_id, closeout_form_id: cof.id})
    @cof_dept.save
    issue.next_responsible_departments.each do |nrd|
      @cof_dept=cof.closeout_form_depts.build({dept_id: nrd.department_id, closeout_form_id: cof.id})
      @cof_dept.save
    end
  end
  # Check for uniqueness later of Dept_id inside one COF before generating
end
