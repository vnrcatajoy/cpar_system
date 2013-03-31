class IssueAttachmentsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_issue,   only: :destroy

  def create
    @issue = Issue.find_by_id(params[:issue_attachment][:issue_id])
    @issue_attachment = @issue.issue_attachments.build(params[:issue_attachment])
    if @issue_attachment.save
      flash[:success] = "File successfully Attached!"
      redirect_to issue_path(@issue)
    else
      flash[:error]  = "There was an error saving your image."
      redirect_to :back
    end
  end

  def destroy
    @issue_attachment.destroy
    redirect_to issue_path(@issue)
  end

  private

    def correct_issue
      @issue= Issue.find(params[:issue_id])
      redirect_to issue_path(@issue) if @issue.nil?
      @issue_attachment = @issue.issue_attachments.find_by_id(params[:id])
      redirect_to issue_path(@issue) if @issue_attachment.nil?
    end
end