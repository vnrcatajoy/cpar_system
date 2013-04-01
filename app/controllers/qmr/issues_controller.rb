class Qmr::IssuesController < ApplicationController
  before_filter :signed_in_user
  before_filter :qmr_user

  def index
     @issues = Issue.paginate(page: params[:page], per_page: 5)
     @issues_new = Issue.where("status_id = 1").paginate(page: params[:page], per_page: 5)
     @issues_rejected = Issue.where("status_id = 7").paginate(page: params[:page], per_page: 5)
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
    # moved Causes and ActionPlans to details view
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
  end

  def edit
    @issue = Issue.find params[:id]
  end

  def edit_departments
    @issue = Issue.find params[:id]
    @nrds = depts_added_to_issue(@issue)
    @next_responsible_department = NextResponsibleDepartment.new
  end

  def statuschange
    issue = Issue.find params[:id]
    issue.status_id = params[:stat_id]
    if issue.save
      flash[:success] = "Issue Status updated."
      redirect_to qmr_issue_path
    end
  end

  def update
    issue = Issue.find params[:id]
    if issue.department_id != params[:issue][:department_id]
      # Department has been changed; Only changeable in edit_departments
      new_department1_is_in_depts(issue, params[:issue][:department_id])
    end
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

  def new_department1_is_in_depts(issue, new_dept_id)
    # Use: Pop Department in issue.NRD if it's to be Assigned to issue.Department1
    # If it's not already in issue.NRD, just save the new addition to NRD
    # (Push the PREVIOUS Department1 pushed off Top1 to issue.NRD)
    #depts_under_issue = Array.new #Array of department ids already added
    #outmessage=""
    nrds= NextResponsibleDepartment.where(issue_id: issue.id)
    destroyed=false
    #testmessage=""
    nrds.each do |nrd|
      #testmessage += "["+ nrd.department_id.to_s + ", " + new_dept_id.to_s + "] "
       if nrd.department_id.to_s == new_dept_id.to_s
          #outmessage += "Successfully Popped Department with id of " + new_dept_id + " off NRD. "
          nrd.destroy
          destroyed=true
       end
    end
    if destroyed
      @nrd_new = issue.next_responsible_departments.build({issue_id: issue.id, department_id: issue.department_id, dept_status_id: issue.status_id, responsibility_level: 2 })
      # Add previous 1st Department under Issue to issue.NextResponsibleDepartment
      if @nrd_new.save
        #outmessage += "Successfully Pushed previous Department1 into NRD instead."
      end
    end
    #flash[:success]= outmessage+" || "+testmessage
  end

  def depts_added_to_issue(issue)
    depts_under_issue = Array.new #Array of department ids already added
    depts_under_issue << issue.department_id
    found_dept = true
    nrds= NextResponsibleDepartment.where(issue_id: @issue.id)
    nrds.each do |nrd|
       depts_under_issue << nrd.department_id
    end
    depts_under_issue
  end
end
