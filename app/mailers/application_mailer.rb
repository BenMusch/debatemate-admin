class ApplicationMailer < ActionMailer::Base
  default from: "noreply@debatemate.herokuapp.com"
  layout 'mailer'
end
