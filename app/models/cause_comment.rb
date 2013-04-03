class CauseComment < ActiveRecord::Base
  attr_accessible :cause_id, :content, :user_id #, :log_comment protected
  belongs_to :cause
end
