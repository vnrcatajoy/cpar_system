class Issue < ActiveRecord::Base
  belongs_to :user
  belongs_to :department
  belongs_to :issue_impact, :foreign_key => 'impact_id', :class_name => 'IssueImpact'
  belongs_to :issue_status, :foreign_key => 'status_id', :class_name => 'IssueStatus'
  belongs_to :issue_type, :foreign_key => 'type_id', :class_name => 'IssueType'
  belongs_to :iso_nc, :foreign_key => 'iso_nc_id', :class_name => 'IsoNc'

  attr_accessible :action_plan_id, :cause_id, :department_id, :description, :impact_id, :iso_nc_id, :user_id, :status_id, :title, :type_id

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true
  validates :user_id, presence: true
  validates :status_id, presence: true
  validates :impact_id, presence: true

end
