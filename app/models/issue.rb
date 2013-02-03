class Issue < ActiveRecord::Base
  belongs_to :user
  belongs_to :department
  belongs_to :issue_impact, :foreign_key => 'impact_id'
  belongs_to :issue_status, :foreign_key => 'status_id'
  belongs_to :issue_type, :foreign_key => 'type_id'

  attr_accessible :action_plan_id, :cause_id, :department_id, :description, :impact_id, :iso_nc_id, :user_id, :status_id, :title, :type_id
end
