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
      flash[:success] = 'The issue has been created!'
      redirect_to qmr_issues_path
    else
      flash[:success] = 'There was an error in creating your issue.'
      redirect_to :back
    end
  end

  def show
    @issue = Issue.find params[:id]
    # moved Causes and ActionPlans to details view
    @issue_comment = IssueComment.new
    @issuecomments = @issue.issue_comments.where(log_comment: 'f').paginate(page: params[:page],  per_page: 3)
    @issueupdates = @issue.issue_comments.where(log_comment: 't').paginate(page: params[:page],  per_page: 5)
  end

  def details
    @issue = Issue.find params[:id]
    @causes= @issue.causes.paginate(page: params[:page],  per_page: 5)
    @action_plans = ActionPlan.where("issue_id = " + @issue.id.to_s).paginate(page: params[:page], per_page: 5)
    @cof = CloseoutForm.find_by_issue_id(@issue.id)
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

  def sign_closeout
    @issue = Issue.find params[:id]
    @cof = CloseoutForm.find_by_id(params[:cof])
    if @cof.qmr_id == nil 
      @cof.qmr_id = current_user.id
      @cof.closeout_date = Date.today
      if @cof.save
        @issue.status_id = 6 #Closed
        if @issue.save
          flash[:success] = 'Successfully signed Closeout Form and Closed Issue!'
          redirect_to details_qmr_issue_path(@issue)
        end
      end
    end
  end

  def update
    issue = Issue.find params[:id]
    if issue.department_id != params[:issue][:department_id]
      # Department has been changed; Only changeable in edit_departments
      new_department1_is_in_depts(issue, params[:issue][:department_id])
    end
    if issue.update_attributes params[:issue]
      flash[:success] = 'The issue has been updated successfuly!'  
      redirect_to qmr_issue_path
    else
      flash[:error]='There was an error in updating your issue.'
      redirect_to :back
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
