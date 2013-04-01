class CloseoutForm < ActiveRecord::Base
  attr_accessible :auditor_id, :closeout_date, :completed, :issue_id, :qmr_id
  belongs_to :issue
end
