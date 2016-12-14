class Sendgrid::SendgridList

  LANDING_URL = "https://sendgrid.com/api/newsletter/lists/"

  ENVIRONMENT_BASED_LIST_APPENDER = "(test)" #"#{Rails.env.production? ? '' : '('+Rails.env+')'}"

  DELAY_PRIORITY_HASH = { :priority => 10 }

  def self.get_credentials
    {:api_user => SENDGRID_SETTINGS[:user_name], :api_key => SENDGRID_SETTINGS[:password]}
  end

  def self.user_params(user_subscriber)
    {:email => user_subscriber.email, :name => user_subscriber.user_firstname}.to_json
  end

  def self.create_list(list_name)
    uri = URI.encode(url_for_action("add", "list=#{list_name}&name=name"))
    url = URI uri
    send_request(url)
  end

  def self.edit_list(list_name, new_list)
    uri = URI.encode(url_for_action("edit", "list=#{list_name}&new_list=#{new_list}"))
    url = URI uri
    send_request(url)
  end

  def self.delete_list(list_name)
    uri = URI.encode(url_for_action("delete", "list=#{list_name}"))
    url = URI uri
    send_request(url)
  end

  def self.add_to_list(list_name, user_subscribers)
    uri = URI.encode(url_for_action("email/add", "list=#{list_name}"))
    url = URI(uri)
    send_request(url, form_data_for_addition(user_subscribers))
  end

  def self.delete_from_list(list_name, email)
    uri = URI.encode(url_for_action("email/delete", "list=#{list_name}"))
    url = URI(uri)
    send_request(url, form_data_for_deletion(email))
  end

  def self.form_data_for_deletion(email)
    { "email" => email }
  end

  def self.form_data_for_addition(user_subscribers)
    {"data[]" => generate_users_list_params(user_subscribers)}
  end

  def self.url_for_action(action, extra_params)
    "#{LANDING_URL}#{action}.json?#{extra_params}"
  end

####TODO use Httparty or make sure response body in this case can be used to raise specific type of exception as mentioned below.

  def self.send_request(uri, form_data = {})
    Net::HTTP.start(uri.host, uri.port,
      :use_ssl => true) do |http|
      request = Net::HTTP::Post.new uri.request_uri
      request.set_form_data(form_data.merge(get_credentials))
      response = http.request request
      # response_body = response.body
      # puts response_body
      # if response.code.to_i > 401
      #   raise(Sendgrid::SendgridServerError, "The sengrid server returned an error. #{response_body}")
      # elsif has_error?(response_body) and response_body['error'].respond_to?(:has_key?) and response_body['error'].has_key?('code') and response_body['error']['code'].to_i == 401
      #   raise Sendgrid::AuthenticationFailed
      # elsif has_error?(response_body)
      #   raise(Sendgrid::SendgridApiError, response_body['error'])
      # end
      response.body
    end
  end

  # def self.has_error?(response)
  #   puts response.class
  #   puts response.kind_of?(Hash) && response.has_key?('error')
  #   response.kind_of?(Hash) && response.has_key?('error')
  # end

  # def self.post(url, opts = {})
  #   response = HTTParty.post(url, :query => get_credentials.merge(opts), :format => :json)
  #   puts response.inspect
  #   if response.code > 401
  #     raise(Sendgrid::SendgridServerError, "The sengrid server returned an error. #{response.inspect}")
  #   elsif has_error?(response) and response['error'].respond_to?(:has_key?) and response['error'].has_key?('code') and response['error']['code'].to_i == 401
  #     raise Sendgrid::AuthenticationFailed
  #   elsif has_error?(response)
  #     raise(Sendgrid::SendgridApiError, response['error'])
  #   end
  #   response
  # end

  def self.all_subscriber_list_name
    "All Subscribers#{ENVIRONMENT_BASED_LIST_APPENDER}"
  end

  def self.without_age_list_name
    "Subscribers(without age)#{ENVIRONMENT_BASED_LIST_APPENDER}"
  end

  def self.without_gender_list_name
    "Subscribers(without gender)#{ENVIRONMENT_BASED_LIST_APPENDER}"
  end

  def self.age_group_list_name(age_bracket)
    "#{age_bracket} age group Subscribers#{ENVIRONMENT_BASED_LIST_APPENDER}"
  end

  def self.list_name_by_state(state_name)
    "#{state_name} Subscribers#{ENVIRONMENT_BASED_LIST_APPENDER}"
  end

  def self.gender_based_list(gender)
    "#{gender} Subscribers#{ENVIRONMENT_BASED_LIST_APPENDER}"
  end

  def self.all_users_list
    "All Users#{ENVIRONMENT_BASED_LIST_APPENDER}"
  end

  def self.all_promo_subscribers_list
    "All Promo Subscribers#{ENVIRONMENT_BASED_LIST_APPENDER}"
  end

  def self.generate_users_list_params(user_subscribers)
    params_for_user = []
    user_subscribers.each do |user_subscriber|
      params_for_user << "#{user_params(user_subscriber)}"
    end
    params_for_user
  end

end
