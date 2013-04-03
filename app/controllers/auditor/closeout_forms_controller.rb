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
  		flash[:success] = "Closeout Form successfully started!" + outstring
      redirect_to details_auditor_issue_path(@issue)
        #don't change yet - this actually generates the COF departments under one COF, in Issues Details view
      else
        flash[:error]  = "There was an error creating the form."
        redirect_to :back
  	end
  end

  private

  def auditor_user
    redirect_to(root_path) unless current_user.type_id==5
  end
end
