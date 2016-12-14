module Sendgrid::SendGridMethods
  
  private
  def update_list(subscription, list_name)
    subscription.status_was ? delete_from_subscribers_list(subscription, list_name) : add_to_subscribers_list(subscription, list_name)
  end


  def add_to_subscribers_list(subscription, list_name)
    Sendgrid::SendgridList.delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).add_to_list(list_name, [subscription])
  end

  def delete_from_subscribers_list(subscription, list_name)
    Sendgrid::SendgridList.delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).delete_from_list(list_name, subscription.email)
  end

end