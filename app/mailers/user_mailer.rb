class UserMailer < ActionMailer::Base
  default from: "WebCPAR <smtp://localhost:1025>"

  def welcome_email(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Successfully Registered to Web CPAR!")
  end
end