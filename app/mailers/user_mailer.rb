class UserMailer < ActionMailer::Base
  default from: "webcpartest@gmail.com"

  def welcome_email(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Successfully Registered to Web CPAR!")
  end
end