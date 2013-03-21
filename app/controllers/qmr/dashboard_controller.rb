class Qmr::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :qmr_user

  def index
  	@issues = Issue.all
  	@issues_new = Issue.where("status_id = 1")
  	@issues_rejected = Issue.where("status_id = 7")
  end

  private

  def qmr_user
      redirect_to(root_path) unless current_user.type_id==4
  end
end
