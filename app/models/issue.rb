class Issue < ActiveRecord::Base
  belongs_to :user
  belongs_to :department

  attr_accessible :action_plan_id, :cause_id, :department_id, :description, :impact_id, :iso_nc_id, :user_id, :status_id, :title, :type_id
end
