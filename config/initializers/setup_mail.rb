#if Rails.env != 'test'
  #email_settings = YAML::load(File.open("#{Rails.root.to_s}/config/email.yml"))
  #ActionMailer::Base.smtp_settings = email_settings[Rails.env] unless email_settings[Rails.env].nil?
#end
# begin
#   sock = TCPSocket.new("localhost", 1025)
#   sock.close
#   catcher = true
# rescue
#   catcher = false
# end

ActionMailer::Base.smtp_settings = {
	:address => "smtp.gmail.com",
	:port => 587,
	:domain => "webcpar12.herokuapp.com",
	:user_name => "webcpartest@gmail.com",
	:password => "09152151552",
	:authentication => "plain",
	:enable_starttls_auto => true
	} 
#end
#&& catcher
#   { :address => "localhost", 
#   	:port => '1025' } 
# else
	# {
	# :address => "smtp.gmail.com",
	# :port => 587,
	# :domain => "webcpar12.herokuapp.com",
	# :user_name => "webcpartest@gmail.com",
	# :password => "09152151552",
	# :authentication => "plain",
	# :enable_starttls_auto => true
	# }


ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true

if Rails.env != 'production'
	ActionMailer::Base.default_url_options[:host] = "localhost:3000"
else
	ActionMailer::Base.default_url_options[:host] = "webcpar12.herokuapp.com"
	#replace later with production url
end

ActionMailer::Base.default :content_type => "text/html"

require 'development_mail_interceptor'
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?