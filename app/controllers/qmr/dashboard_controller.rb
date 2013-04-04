class Qmr::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :qmr_user

  def index
  	@issues = Issue.all
  	@issues_new = Issue.where("status_id = 1")
  	@issues_rejected = Issue.where("status_id = 7")
    @issues_closeout = Issue.where("status_id = 5")
    @closeoutforms_all = CloseoutForm.all
    @closeoutforms_closed = CloseoutForm.where(qmr_id: current_user.id, completed: 't')
  end

  private

  def qmr_user
      redirect_to(root_path) unless current_user.type_id==4
  end
end
