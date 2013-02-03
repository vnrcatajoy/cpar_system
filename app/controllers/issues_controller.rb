class IssuesController < ApplicationController
  def index
    @issues = Issue.all
    @users = User.all
  end

  def new
    @issue = Issue.new
  end

end
