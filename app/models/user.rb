class User < ActiveRecord::Base
  has_many :issues
  belongs_to :user_type, :foreign_key => 'type_id'
  belongs_to :department

  attr_accessible :department_id, :email, :mobile, :name, :phone, :type_id, 
  						:password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = email.downcase }

  validates :name,  presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
