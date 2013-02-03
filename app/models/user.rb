class User < ActiveRecord::Base
  has_many :issues
  belongs_to :user_type, :foreign_key => 'type_id'
  belongs_to :department

  attr_accessible :department_id, :email, :mobile, :name, :phone, :type_id
end
