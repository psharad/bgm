class Emailer < ActionMailer::Base
  CODE = BetaKey.find(:first).beta_key

  def user_credentials(group, user)
    subject       "Thank you!"  
    from          "Connecting Sexes<info@connectingsexes.com>"
    recipients    user.email
    sent_on       Time.now
    body          :user => user, :group => group
    content_type "text/html"
  end

  def reset_password_request(user)
    subject       "Reset Password Request"  
    from          "Connecting Sexes<info@connectingsexes.com>"
    recipients    user.email
    sent_on       Time.now
    body          :user => user
    content_type "text/html"
  end

  def reset_password(user, password)
    subject       "New Blind Match Group Credentials"  
    from          "Connecting Sexes<info@connectingsexes.com>"
    recipients    user.email
    sent_on       Time.now
    body          :user => user, :password => password
    content_type "text/html"
  end

  def group_members(member, leader, group)
    subject       "You have been invited"  
    from          "Connecting Sexes<info@connectingsexes.com>"
    bcc           member.email
    sent_on       Time.now
    body          :member => member, :group => group, :token => leader.memberships.first.token
    content_type "text/html"
  end
  
  def email_with_message(group, sender, message)
    @emails = (sender.groups.current_group.members + group.members + group.user.to_a + sender.to_a).map(&:email).uniq.join(", ")
    subject       "Anonymous User has sent you an email"  
    from          "Connecting Sexes<info@connectingsexes.com>"
    bcc           @emails
    sent_on       Time.now
    body          :group => group, :emails => @emails, :message => message, :sender => sender
    content_type "text/html"
  end
  
  def report(group)
    subject       "Report from a user"  
    from          "Connecting Sexes<info@connectingsexes.com>"
    bcc           ["marvinl@sourcepad.com", "victorm@sourcepad.com", "michaels@sourcepad.com", "info@connectingsexes.com"]
    sent_on       Time.now
    body         :group => group
    content_type "text/html"
  end
  
  def beta_key_request(email, message)
    subject       "Request Beta Key"  
    from          email
    bcc           ["marvinl@sourcepad.com", "victorm@sourcepad.com", "michaels@sourcepad.com", "info@connectingsexes.com"]
    sent_on       Time.now
    body          :message => message, :email => email
    content_type "text/html"
  end
  
  def suggest(user, email)
    subject       "You have been invited"
    from          "Connecting Sexes<info@connectingsexes.com>"
    recipients    email
    sent_on       Time.now
    body          :user => user, :email => email
    content_type  "text/html"
  end

  def local_offer(email, local_offer)
    subject       "Local Offer"
    from          "Connecting Sexes<info@connectingsexes.com>"
    recipients    email
    sent_on       Time.now
    body          :email => email, :local_offer => local_offer
    content_type  "text/html"
  end
  
end
