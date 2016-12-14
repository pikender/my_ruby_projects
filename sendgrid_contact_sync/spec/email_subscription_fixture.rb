class String
  def present?
    nil?
  end
end
class EmailSubscription
  attr_accessor :email, :state_id, :token, :user_id, :status

  def initialize(email)
    @email = email
  end

  def user_firstname
    nil
  end
end

class User
  attr_accessor :email

  def initialize(email)
    @email = email
  end

  def age_bracket
    '30-35'
  end
end

module Delayed
  class Job
  end
end

def email_subscriptions(name)
   e = EmailSubscription.new('adam4@gmail.com')
   e.state_id = 1
   e.token = 1
   e.user_id = 1
   e.status = 1
   e
end
