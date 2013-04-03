class IssueComment < ActiveRecord::Base
  attr_accessible :content, :issue_id, :user_id #, :log_comment protected
  belongs_to :issue
end
