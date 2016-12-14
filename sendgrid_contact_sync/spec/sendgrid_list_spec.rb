require 'spec_helper'

describe Sendgrid::SendgridList do
  #fixtures :email_subscriptions

  shared_examples_for "receive send_request" do |data|
    it "should receive send_request" do
      Sendgrid::SendgridList.should_receive(:send_request).with(@string, data)
    end
  end

  shared_examples_for "receives url_for_action" do |action, extra_params|
    it "should_receive url_for_action" do
      Sendgrid::SendgridList.should_receive(:url_for_action).with(action, extra_params).and_return(true)
    end
  end


  describe 'constants' do
    it "LANDING_URL should have common url" do
      Sendgrid::SendgridList::LANDING_URL.should eq("https://sendgrid.com/api/newsletter/lists/")
    end

    describe 'ENVIRONMENT_BASED_LIST_APPENDER' do
      context "ENVIRONMENT_BASED_LIST_APPENDER should give based on environment" do

        it "should return (test)" do
          Sendgrid::SendgridList::ENVIRONMENT_BASED_LIST_APPENDER.should eq("(test)")
        end
      end
    end

    describe 'DELAY_PRIORITY_HASH' do
      it "should return priority hash" do
        Sendgrid::SendgridList::DELAY_PRIORITY_HASH.should eq({:priority => 10})
      end
    end

  end

  describe '.get_credentials' do
    it "should return authentication_params" do
      Sendgrid::SendgridList.get_credentials.should eq({:api_user => SENDGRID_SETTINGS[:user_name], :api_key => SENDGRID_SETTINGS[:password]})
    end
  end

  describe '.user_params' do
    before do
      @subscription = email_subscriptions(:adam_simja_email_subscriptions)
    end

    it "should return subscription detail hash" do
      Sendgrid::SendgridList.user_params(@subscription).should eq({:email => @subscription.email, :name => @subscription.user_firstname}.to_json)
    end
  end

  describe '.create_list' do
    before do
      Sendgrid::SendgridList.stub(:send_request).and_return(true)
      @string = "added"
      URI.stub(:encode).and_return(@string)
      Sendgrid::SendgridList.stub(:URI).and_return(@string)
    end

    it "should receive send_request" do
      Sendgrid::SendgridList.should_receive(:send_request).with(@string)
    end

    it_behaves_like "receives url_for_action", "add", "list=Subscribers&name=name"
    
    after do
      Sendgrid::SendgridList.create_list("Subscribers")
    end
  end


  describe '.edit_list' do
    before do
      Sendgrid::SendgridList.stub(:send_request).and_return(true)
      @string = "added"
      URI.stub(:encode).and_return(@string)
      Sendgrid::SendgridList.stub(:URI).and_return(@string)
    end

    it "should receive send_request" do
      Sendgrid::SendgridList.should_receive(:send_request).with(@string)
    end

    it_behaves_like "receives url_for_action", "edit", "list=Subscribers&new_list=name"
    
    after do
      Sendgrid::SendgridList.edit_list("Subscribers", "name")
    end
  end

  describe '.delete_list' do
    before do
      Sendgrid::SendgridList.stub(:send_request).and_return(true)
      @string = "added"
      URI.stub(:encode).and_return(@string)
      Sendgrid::SendgridList.stub(:URI).and_return(@string)
    end

    it "should receive send_request" do
      Sendgrid::SendgridList.should_receive(:send_request).with(@string)
    end

    it_behaves_like "receives url_for_action", "delete", "list=Subscribers"
    
    after do
      Sendgrid::SendgridList.delete_list("Subscribers")
    end
  end

  describe '.add_to_list' do
    before do
      Sendgrid::SendgridList.stub(:send_request).and_return(true)
      @string = "added"
      URI.stub(:encode).and_return(@string)
      Sendgrid::SendgridList.stub(:URI).and_return(@string)
    end

    it_behaves_like "receive send_request", {"data[]"=>["{\"email\":\"adam4@gmail.com\",\"name\":null}"]}

    it_behaves_like "receives url_for_action", "email/add", "list=Subscribers"
    
    after do
      Sendgrid::SendgridList.add_to_list("Subscribers", [email_subscriptions(:adam_simja_email_subscriptions)])
    end
  end

  describe '.delete_from_list' do
    before do
      Sendgrid::SendgridList.stub(:send_request).and_return(true)
      @string = "added"
      URI.stub(:encode).and_return(@string)
      Sendgrid::SendgridList.stub(:URI).and_return(@string)
    end

    it_behaves_like "receive send_request", {"email"=>"adam4@gmail.com"}

    it_behaves_like "receives url_for_action", "email/delete", "list=Subscribers"
    
    after do
      Sendgrid::SendgridList.delete_from_list("Subscribers", email_subscriptions(:adam_simja_email_subscriptions).email)
    end
  end


  describe '.form_data_for_deletion' do
    before do
      @subscription = email_subscriptions(:adam_simja_email_subscriptions)
    end

    it "should return data hash for deletion" do
      Sendgrid::SendgridList.form_data_for_deletion(@subscription.email).should eq({"email" => @subscription.email})
    end
  end

  describe '.form_data_for_addition' do
    before do
      @subscription = email_subscriptions(:adam_simja_email_subscriptions)
    end

    it "should return data hash for addition" do
      Sendgrid::SendgridList.form_data_for_addition([@subscription]).should eq({"data[]" => Sendgrid::SendgridList.generate_users_list_params([@subscription])})
    end
  end

  describe '.all_subscriber_list_name' do
    it "should give list name for all Subscribers" do
      Sendgrid::SendgridList.all_subscriber_list_name.should eq("All Subscribers(test)")
    end
  end

  describe '.without_age_list_name' do
    it "should give list name for without age Subscribers" do
      Sendgrid::SendgridList.without_age_list_name.should eq("Subscribers(without age)(test)")
    end
  end

  describe '.without_gender_list_name' do
    it "should give list name for without gender specified Subscribers" do
      Sendgrid::SendgridList.without_gender_list_name.should eq("Subscribers(without gender)(test)")
    end
  end

  describe '.age_group_list_name' do
    it "should give list name for age group based Subscribers" do
      Sendgrid::SendgridList.age_group_list_name("10-18").should eq("10-18 age group Subscribers(test)")
    end
  end

  describe '.list_name_by_state' do
    it "should give list name for state filtered Subscribers" do
      Sendgrid::SendgridList.list_name_by_state("lagos").should eq("lagos Subscribers(test)")
    end
  end

  describe '.gender_based_list' do
    it "should give list name for gender filtered Subscribers" do
      Sendgrid::SendgridList.gender_based_list("Male").should eq("Male Subscribers(test)")
    end
  end

  describe '.url_for_action' do
    it "should return url for specified action" do
      Sendgrid::SendgridList.url_for_action("new", "").should eq("#{Sendgrid::SendgridList::LANDING_URL}new.json?")
    end
  end

  describe '.all_users_list' do
    it "should return list name for all users" do
      Sendgrid::SendgridList.all_users_list.should eq("All Users#{Sendgrid::SendgridList::ENVIRONMENT_BASED_LIST_APPENDER}")
    end
  end


  describe '.send_request' do
    before do
      @data = {:email => 's@s.com'}
      @string = "#{Sendgrid::SendgridList::LANDING_URL}email/delete.json?list=Subscribers"
      @request = Net::HTTP::Post.new(@string)
      @string.stub(:host).and_return("http://sendgrid.com")
      @string.stub(:port).and_return("3000")
      Net::HTTP::Post.stub(:new).and_return(@request)
      @string.stub(:request_uri).and_return(@string)
      @request.stub(:set_form_data).and_return(@data)
      @http = mock :http
      Net::HTTP.stub!(:start).and_yield @http
      @response = "200"
      @http.stub(:request).and_return(@response)
      @response.stub(:body).and_return("ok")
      @data.stub(:merge).and_return(@data)
      Sendgrid::SendgridList.stub(:get_credentials).and_return({})
    end

    it "should_receive request" do
      @http.should_receive(:request).with(an_instance_of(Net::HTTP::Post)).and_return @response
    end

    it "should_receive Net::HTTP::Post.new" do
      Net::HTTP::Post.should_receive(:new).and_return(@request)
    end

    it "should_receive host" do
      @string.should_receive(:host).and_return("abc")
    end

    it "should_receive host" do
      @string.should_receive(:port).and_return(100)
    end

    it "request should_receive set_form_data" do
      @request.should_receive(:set_form_data).with(@data)
    end

    after do
      Sendgrid::SendgridList.send_request(@string, @data)
    end
  end



  describe '.generate_users_list_params' do
    it "should return params for adding user to list" do
      result = Sendgrid::SendgridList.generate_users_list_params([email_subscriptions(:adam_simja_email_subscriptions), email_subscriptions(:adam_oyo_email_subscriptions)])
      result.should eq(["#{Sendgrid::SendgridList.user_params(email_subscriptions(:adam_simja_email_subscriptions))}", "#{Sendgrid::SendgridList.user_params(email_subscriptions(:adam_oyo_email_subscriptions))}"])
    end
  end
end
