class UserMailer < ActionMailer::Base
  
  def welcome_email(user)
    recipients    user.email
    from          "My Awesome Site Notifications <notifications@example.com>"
    subject       "Welcome to My Awesome Site"
    sent_on       Time.now
    body          :user => user, :url => "http://example.com/login"
  end
  

  def approval_email(user)
    recipients    user.email
#    from          "BPAD <mvilrokx@rws65855fwks.us.oracle.com>"
    subject       "Approvals are awaiting"
    sent_on       Time.now
    body          "BPAD!!!"
  end
  
end
