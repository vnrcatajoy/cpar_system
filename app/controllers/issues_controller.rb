class IssuesController < ApplicationController
  def index
    @issues = Issue.all
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new params[:issue]

    if @issue.save
      redirect_to issues_path, notice: 'Issue has successfuly been created!'
    else
      format.html  { render :action => "new" }
      format.json  { render :json => @issue.errors,
                    :status => :unprocessable_entity }
    end
  end

  def show
    @issue = Issue.find params[:id]

  end

end
