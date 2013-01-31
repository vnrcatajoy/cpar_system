class IssuesController < ApplicationController
  def index
  	@index = Issue.new
    @issues = Issue.all
  end
end
