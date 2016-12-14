class SendgridUserSyncService
  attr_reader :user, :email

  def initialize(email, user=nil)
    @email = email
    @user = user
  end

  def delay_add_to_users_list
    delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).add_to_users_list
  end

  def delay_delete_from_users_list
    delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).delete_from_users_list
  end

  def sync_user_properties
    update_subscription if user.firstname_changed?
    manage_age_list if user.age_bracket_changed?
    manage_gender_list if user.gender_changed?
    delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).update_all_users_list_for_status if user.status_changed?
  end

  def add_to_users_list
    Sendgrid::SendgridList.add_to_list(Sendgrid::SendgridList.all_users_list, [user])
  end

  def delete_from_users_list
    Sendgrid::SendgridList.delete_from_list(Sendgrid::SendgridList.all_users_list, email)
  end

  private

  def update_all_users_list_for_status
    user.status? ? add_to_users_list : delete_from_users_list
  end

  def manage_gender_list
    add_to_new_and_remove_from_old_list(user, user.gender, user.gender_was, "gender")
    remove_from_list(user, Sendgrid::SendgridList.without_gender_list_name) if user.gender_was.nil?
  end

  def manage_age_list
    add_to_new_and_remove_from_old_list(user, user.age_bracket, user.age_bracket_was, "age")
    remove_from_list(user, Sendgrid::SendgridList.without_age_list_name) if user.age_bracket_was.nil?
  end

  def update_all_users_list(user)
    delete_from_users_list
    add_to_users_list
  end

  def add_to_new_and_remove_from_old_list(user, new_value, old_value, list_type)
    if (subscription = user.email_subscription.enabled.first)
      old_list = get_list_name(list_type, old_value)
      new_list = get_list_name(list_type, new_value)
      Sendgrid::SendgridList.delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).delete_from_list(old_list, subscription.email) if old_value.present?
      Sendgrid::SendgridList.delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).add_to_list(new_list, [subscription])
    end
  end

  def get_list_name(list_type, value)
    list_type == "age" ? Sendgrid::SendgridList.age_group_list_name(value) : Sendgrid::SendgridList.gender_based_list(value)
  end

  def update_subscription
    update_subscription_for_state(user)
    delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).update_all_users_list(user)
    if (subscription = user.email_subscription.enabled.first)
      delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).update_list(subscription, Sendgrid::SendgridList.all_subscriber_list_name)
      delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).update_list(subscription, list_name_for_age_group(user))
      delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).update_list(subscription, list_name_for_gender_group(user))
    end
  end

  def list_name_for_age_group(user)
    user.age_bracket? ? Sendgrid::SendgridList.age_group_list_name(user.age_bracket) : Sendgrid::SendgridList.without_age_list_name
  end

  def list_name_for_gender_group(user)
    user.gender? ? Sendgrid::SendgridList.gender_based_list(user.gender) : Sendgrid::SendgridList.without_gender_list_name
  end

  def remove_from_list(user, list_name)
    if (subscription = user.email_subscription.enabled.first)
      Sendgrid::SendgridList.delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).delete_from_list(list_name, subscription.email)
    end
  end

  def update_subscription_for_state(user)
    user_subscriptions = user.email_subscription.enabled
    user_subscriptions.each do |subscription|
      delay(Sendgrid::SendgridList::DELAY_PRIORITY_HASH).update_list(subscription, Sendgrid::SendgridList.list_name_by_state(subscription.state_name))
    end
  end

  def update_list(subscription, list_name)
    Sendgrid::SendgridList.delete_from_list(list_name, subscription.email)
    Sendgrid::SendgridList.add_to_list(list_name, [subscription])
  end

end
