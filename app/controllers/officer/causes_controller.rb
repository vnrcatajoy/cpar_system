class Officer::CausesController < ApplicationController
  before_filter :signed_in_user
  before_filter :responsibleofficer_user
  before_filter :issue_notnil
  before_filter :set_user
  before_filter :assigned_officer, only: [:new, :edit, :destroy]

  def new
  	@cause = Cause.new(params[:cause])
  end

  def create
    @cause = @issue.causes.build(params[:cause])
    @cause.user_id = @user.id
    if @cause.save
      if @issue.status_id == 3
        @issue.status_id = 4 
        if @issue.save
          flash[:success] = "Successfully added new Cause! Updated Issue status to \'Correcting\'." 
          redirect_to [:officer, @issue]
        end
      else
        flash[:success] = "Successfully added new Cause!." 
        redirect_to [:officer, @issue]
      end
    else
      flash.now[:error] = "Please fill in the fields properly." 
      render 'new'
    end
  end

  def show
    @cause=Cause.find(params[:id])
  end

  def edit
    flash[:success] = "Editing Cause" 
    #@cause = Cause.find(params[:id])
    @cause = @issue.causes.find(params[:id])
  end

  def update
    #@cause = Cause.find(params[:id])
    @cause = @issue.causes.find(params[:id])
    if @cause.update_attributes(params[:cause])
      flash[:success] = "Cause updated."
      redirect_to [:officer, @issue]
    else
      flash.now[:error] = "Please don't leave the fields blank."
      render 'edit'
    end
  end

  def destroy
    Cause.find(params[:id]).destroy
    flash[:success] = "Cause destroyed!"
    redirect_to [:officer, @issue]
  end

  private

  def issue_notnil
    @issue = Issue.find(params[:issue_id])
  end

  def set_user
    @user = current_user
  end

  def responsibleofficer_user
    redirect_to(root_path) unless current_user.type_id==3
  end

  def assigned_officer 
    if @issue.responsible_officer_id != current_user.id
      flash[:error] = "You're not allowed to Add or Edit Causes for Issues not assigned to you."
      redirect_to officer_issues_path
    end
  end
end
