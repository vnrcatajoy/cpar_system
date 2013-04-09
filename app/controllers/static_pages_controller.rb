class StaticPagesController < ApplicationController
  def home
  	@issues = Issue.all
  	@issues_closed = Issue.where("final_closeout_date between ? and ?", Date.today.at_beginning_of_month, Date.today.next_month.beginning_of_month)
  	@issues_thismonth = Issue.where("created_at between ? and ?", Date.today.at_beginning_of_month, Date.today.next_month.beginning_of_month)
    @issues_pending = Issue.where("final_closeout_date is NULL").count #.sum(:total_price)
    @issues_rejected = Issue.where("status_id = 7").count
  	# can also use this format YourModel.where(:created_at => start_date..end_date)
  	@issues_total = Issue.all.count.to_f
  	@issues_admin = Issue.where("department_id = 1").count / @issues_total
    @issues_admin = @issues_admin.round(2)
  	@issues_maintenance = Issue.where("department_id = 2").count / @issues_total
    @issues_maintenance = @issues_maintenance.round(2)
  	@issues_development = Issue.where("department_id = 3").count / @issues_total
    @issues_development = @issues_development.round(2)
  	@issues_verification = Issue.where("department_id = 4").count / @issues_total
    @issues_verification = @issues_verification.round(2)
  end
end
