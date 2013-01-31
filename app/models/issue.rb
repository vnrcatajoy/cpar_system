class Issue < ActiveRecord::Base
  belongs_to :user
  belongs_to :department

  attr_accessible :action_plan_id, :cause_id, :department_in_charge_id, :description, :impact_id, :iso_nc_id, :originator_id, :status_id, :title, :type_id
end
