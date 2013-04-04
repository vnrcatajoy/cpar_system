class Auditor::CloseoutFormsController < ApplicationController
  before_filter :signed_in_user
  before_filter :auditor_user

  def create
  	@issue = Issue.find_by_id(params[:closeout_form][:issue_id])
  	redirect_to auditor_issues_path if @issue == nil
  	@closeout_form = @issue.closeout_forms.build(params[:closeout_form])
    outstring = ""
  	if @closeout_form.save
      if @issue.status_id == 4
        @issue.status_id = 5
        if @issue.save
          outstring = " Issue Status has been updated to \"Implemented!\"."
        end
      end
      @ic= @issue.issue_comments.build({content: "Auditor started Closeout Form for Issue.",
            user_id: current_user.id, issue_id: @issue.id })
      @ic.toggle!(:log_comment)
      @ic.save
  		flash[:success] = "Closeout Form successfully started!" + outstring + " Refresh the page to see the Departments below."
      redirect_to details_auditor_issue_path(@issue)
      mail_list(@issue) 
      else
        flash[:error]  = "There was an error creating the form."
        redirect_to :back
  	end
  end

  private

  def auditor_user
    redirect_to(root_path) unless current_user.type_id==5
  end

  def mail_list(issue)
    officer = User.find(issue.responsible_officer_id)
    title = "Closeup Form started for one of your Issues"
    content = "One of the Issues you investigated and acted on, "+ issue.title + " has started its Closeout form. Please check back into the site in the Issue details. to sign Form."
    officer.send_notification_email(title, content)
    nrds= NextResponsibleDepartment.where(issue_id: issue.id)
    nrds.each do |nrd|
       officer = User.find(nrd.responsible_officer_id)
       officer.send_notification_email(title, content)
    end
  end
end
