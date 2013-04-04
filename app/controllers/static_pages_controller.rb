class StaticPagesController < ApplicationController
  def home
  	@issues = Issue.all
  	@issues_closed = Issue.where("final_closeout_date between ? and ?", Date.today.at_beginning_of_month, Date.today.next_month.beginning_of_month)
  	@issues_thismonth = Issue.where("created_at between ? and ?", Date.today.at_beginning_of_month, Date.today.next_month.beginning_of_month)
  end
end
