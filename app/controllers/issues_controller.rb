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
      redirect_to issues_path, notice: 'The issue has been created!'
    else
      redirect_to :back, notice: 'There was an error in creating your issue.'
    end
  end

  def show
    @issue = Issue.find params[:id]
  end

  def edit
    @issue = Issue.find params[:id]
  end

  def update
    issue = Issue.find params[:id]

    if issue.update_attributes params[:issue]
      redirect_to issues_path, :notice => 'The issue has been updated successfuly!'  
    else
      redirect_to :back, :notice => 'There was an error in updating your issue.'
    end
  end

  def destroy
    Issue.destroy params[:id]
    redirect_to :back, :notice => 'The issue was successfuly deleted.'
  end

end
