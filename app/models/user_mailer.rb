class UserMailer < ActionMailer::Base

  def approval_email(user, requester, business_process, path)
    recipients    user.email
    from          "BPAD <mark.vilrokx@oracle.com>"
    subject       "Your approval is requested in BPAD."
    sent_on       Time.now
    content_type  "text/html"
    body          :user => user,
                  :requester => requester,
                  :business_process => business_process,
                  :path => path
  end

end

