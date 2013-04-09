class Issue < ActiveRecord::Base
  belongs_to :user
  belongs_to :department
  belongs_to :issue_impact, :foreign_key => 'impact_id', :class_name => 'IssueImpact'
  belongs_to :issue_status, :foreign_key => 'status_id', :class_name => 'IssueStatus'
  belongs_to :issue_type, :foreign_key => 'type_id', :class_name => 'IssueType'
  belongs_to :iso_nc, :foreign_key => 'iso_nc_id', :class_name => 'IsoNc'

  has_many :causes, dependent: :destroy
  has_many :issue_attachments, dependent: :destroy
  has_many :next_responsible_departments, dependent: :destroy
  has_many :issue_comments, dependent: :destroy

  has_many :closeout_forms #but only really has_one

  attr_accessible :action_plan_id, :cause_id, :department_id, :description, :impact_id, :iso_nc_id, :user_id, :status_id, :title, :type_id, :responsible_officer_id, :estimated_closeout_date, :final_closeout_date

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true
  validates :user_id, presence: true
  validates :status_id, presence: true
  validates :impact_id, presence: true

  def found_department(user_department_id)
    found = false
    if self.department_id == user_department_id
      found = true
    else
      nrds= self.next_responsible_departments
      nrds.each do |n|
        if n.department_id == user_department_id
          found=true
        end
      end
    end
    found
  end

  def found_officer(user_id)
    found = false
    if self.responsible_officer_id == user_id
      found = true
    else
      nrds= self.next_responsible_departments
      nrds.each do |n|
        if n.responsible_officer_id == user_id
          found=true
        end
      end
    end
    found
  end

  #scope :in_department, lambda {|user| self.found_department(user) } 

  #scope :assigned_to, lambda {|user| self.found_officer(user) } 

  def new_issues(dept_id)
    where(status_id: 1, department_id: dept_id).count
  end

  def verified_issues(dept_id)
    where(status_id: 2, department_id: dept_id).count
  end

  def investigating_issues(dept_id)
    where(status_id: 3, department_id: dept_id).count
  end

  def correcting_issues(dept_id)
    where(status_id: 4, department_id: dept_id).count
  end

  def implemented_issues(dept_id)
    where(status_id: 5, department_id: dept_id).count
  end

  def closed_issues(dept_id)
    where(status_id: 6, department_id: dept_id).count
  end

  def rejected_issues(dept_id)
    where(status_id: 7, department_id: dept_id).count
  end

  def self.total_on(date)
    where("date(created_at) = ?", date).count #.sum(:total_price)
  end

  def self.pending_on(date)
    where("date(estimated_closeout_date) = ?", date).count #.sum(:total_price)
  end

  def self.total_closed(date)
    where("date(final_closeout_date) = ?", date).count #.sum(:total_price)
  end

end
