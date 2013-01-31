class User < ActiveRecord::Base
  has_many :issue

  attr_accessible :department_id, :email, :mobile, :name, :phone, :type_id
end
