class Dept::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :dept_user
  before_filter :correct_department, only: :show

  def index
  	@issues = Issue.where("department_id = " + current_user.department_id.to_s).paginate(page: params[:page], per_page: 5)
    @issues_verified = Issue.where("department_id = " + current_user.department_id.to_s + " AND status_id = 2").paginate(page: params[:page], per_page: 5)
    @nrds = NextResponsibleDepartment.where("department_id = " + current_user.department_id.to_s)
    @issues_secondary = Array.new
    @nrds.each do |nrd|
      @issues_secondary << Issue.find(nrd.issue_id)
    end
  end

  def sign_closeout
    @issue = Issue.find params[:id]
    @cofd = CloseoutFormDept.find_by_id(params[:cofd])
    if @cofd.dept_head_id == nil 
      @cofd.dept_head_id = current_user.id
      if @cofd.save
        flash[:success] = "Successfully signed Closeout form of Issue!"
        redirect_to details_dept_issue_path(@issue)
      end
    end
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    @cof = CloseoutForm.find_by_issue_id(@issue.id)
  end

  def update
    # Dept/Issues update Would only ever be called by Assign (assign Officer) button
    @issue = Issue.find params[:id]
    @issue.status_id = 3 # Change from Verified to Investigating
    # Sure Verified first because of Assign form condition
    if @issue.update_attributes params[:issue]
      flash[:success] = 'Successfully Assigned Officer to Issue. Issue is now Investigating.'
      redirect_to dept_issues_path
    else
      flash[:error] = 'There was an error in assigning.'
      redirect_to :back
    end
  end

  def show
  	@issue = Issue.find params[:id]
    @users = User.where("department_id = " + current_user.department_id.to_s + " AND type_id = 3")
    # moved Causes and ActionPlans to details view
    @nrd= NextResponsibleDepartment.find_by_issue_id(@issue.id)
    @issue_comment = IssueComment.new
    @issuecomments = @issue.issue_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @issueupdates = @issue.issue_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  private
  def dept_user
      redirect_to(root_path) unless current_user.type_id==2
  end

  def correct_department
    @issue = Issue.find params[:id]
    @nrds = NextResponsibleDepartment.where("issue_id = ?", @issue.id)
    found_nrds = false
    @nrds.each do |n|
      if n.department_id == current_user.department_id
        found_nrds = true
      end
    end
    if found_nrds
      flash[:success] = "Viewing Issue Secondarily assigned to your Department" 
    elsif current_user.department_id != @issue.department_id
      flash[:error] = "You cannot view an Issue not assigned to your Department."
      redirect_to dept_issues_path
    end
  end
end
