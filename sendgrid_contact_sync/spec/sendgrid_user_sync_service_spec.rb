require 'spec_helper'

describe SendgridUserSyncService do
  #fixtures :email_subscriptions

  before do
    @email = "a@b.com"
    #@user = mock_model(User, :email => @email)
    @user = User.new(@email)
    #@job = mock_model(Delayed::Job)
    @job = Delayed::Job.new
    @observer = SendgridUserSyncService.new(@email, @user)
    #@subscription = mock_model(EmailSubscription, :email => @email)
    @subscription = EmailSubscription.new(:email => @email)
    @subscriptions = [@subscription]
    Sendgrid::SendgridList.stub(:delay).and_return(@job)
    @observer.stub(:delay).and_return(@job)
    @job.stub(:delete_from_list).and_return(true)
    @job.stub(:add_to_list).and_return(true)
    @age_bracket = "18-21"
    @list = "#{@age_bracket} age group Subscribers(test)"
    @gender = "Male"
    @gender_list = "#{@gender} Subscribers(test)"
    @old_gender = "Female"
    @old_gender_list = "#{@old_gender} Subscribers(test)"
    @user.stub(:gender).and_return(@gender)
    @user.stub(:gender_was).and_return(@old_gender)
    @old_age_bracket = "21-27"
    @old_age_bracket_list = "#{@old_age_bracket} age group Subscribers(test)"
    @user.stub(:age_bracket).and_return(@age_bracket)
  end


  describe 'update_all_users_list_for_status' do
    before do
      @observer.stub(:add_to_users_list).and_return(true)
      @observer.stub(:delete_from_users_list).and_return(true)
    end

    context 'when user status is true' do
      before do
        @user.stub(:status?).and_return(true)
      end

      it "should_receive add_to_users_list on observer" do
        @observer.should_receive(:add_to_users_list).and_return(true)
        @observer.send(:update_all_users_list_for_status)
      end

      it "should not receive delete_from_users_list on observer" do
        @observer.should_not_receive(:delete_from_users_list).with(@user)
        @observer.send(:update_all_users_list_for_status)
      end
    end

    context 'when user status is false' do
      before do
        @user.stub(:status?).and_return(false)
      end

      it "should_receive delete_from_users_list on observer" do
        @observer.should_receive(:delete_from_users_list).and_return(true)
        @observer.send(:update_all_users_list_for_status)
      end

      it "should not receive add_to_users_list on observer" do
        @observer.should_not_receive(:add_to_users_list).with(@user)
        @observer.send(:update_all_users_list_for_status)
      end
    end
  end

  describe 'after_create' do
    before do
      @job.stub(:add_to_users_list).and_return(true)
    end

    it "should_receive delay on observer" do
      @observer.should_receive(:delay).and_return(@job)
      @observer.delay_add_to_users_list
    end

    it "should_receive add_to_users_list on delay job" do
      @job.should_receive(:add_to_users_list).and_return(true)
      @observer.delay_add_to_users_list
    end
  end

  describe 'after_destroy' do
    before do
      @job.stub(:delete_from_users_list).and_return(true)
    end

    it "should_receive delay on observer" do
      @observer.should_receive(:delay).and_return(@job)
      @observer.delay_delete_from_users_list
    end

    it "should_receive add_to_users_list on delay job" do
      @job.should_receive(:delete_from_users_list).and_return(true)
      @observer.delay_delete_from_users_list
    end
  end

  describe 'add_to_users_list' do
    it "should_receive add_to_users_list" do
      Sendgrid::SendgridList.should_receive(:add_to_list).with(Sendgrid::SendgridList.all_users_list, [@user]).and_return(true)
      @observer.add_to_users_list
    end
  end

  describe 'delete_from_users_list' do
    it "should_receive delete_from_users_list" do
      Sendgrid::SendgridList.should_receive(:delete_from_list).with(Sendgrid::SendgridList.all_users_list, @user.email).and_return(true)
      @observer.delete_from_users_list
    end
  end

  describe 'update_all_users_list' do
    before do
      @observer.stub(:delete_from_users_list).and_return(true)
      @observer.stub(:add_to_users_list).and_return(true)
    end

    it "should_receive add_to_users_list" do
      @observer.should_receive(:add_to_users_list).and_return(true)
      @observer.send(:update_all_users_list, @user)
    end

    it "should_receive delete_from_users_list" do
      @observer.should_receive(:delete_from_users_list).and_return(true)
      @observer.send(:update_all_users_list, @user)
    end
  end

  describe 'manage_age_list' do
    before do
      @user.stub_chain(:age_bracket_was, :nil?).and_return(false)
      @observer.stub(:add_to_new_and_remove_from_old_list).and_return(true)
    end

    it "should_receive add_to_new_and_remove_from_old_list" do
      @observer.should_receive(:add_to_new_and_remove_from_old_list).and_return(true)
      @observer.send(:manage_age_list)
    end

    context 'when age_bracket was not present before' do
      before do
        @user.stub(:age_bracket).and_return(@age_bracket)
        @user.stub(:age_bracket_was).and_return(@old_age_bracket)
        @user.stub(:age_bracket_changed?).and_return(false)
        @user.stub_chain(:age_bracket_was, :nil?).and_return(true)
        @observer.stub(:remove_from_list).and_return(true)
      end

      it "should_receive remove_from_list" do
        @observer.should_receive(:remove_from_list).with(@user, Sendgrid::SendgridList.without_age_list_name).and_return(true)
        @observer.send(:manage_age_list)
      end
    end

    context 'when age_bracket was present before' do
      before do
        @user.stub(:age_bracket_was).and_return(@old_age_bracket)
      end

      it "should not receive remove_from_list" do
        @observer.should_not_receive(:remove_from_list).with(@user, Sendgrid::SendgridList.without_age_list_name)
        @observer.send(:manage_age_list)
      end
    end
  end

  describe 'manage_gender_list' do
    before do
      @user.stub_chain(:gender_was, :nil?).and_return(false)
      @observer.stub(:add_to_new_and_remove_from_old_list).and_return(true)
    end

    it "should_receive add_to_new_and_remove_from_old_list" do
      @observer.should_receive(:add_to_new_and_remove_from_old_list).and_return(true)
      @observer.send(:manage_gender_list)
    end

    context 'when gender was not present before' do
      before do
        @user.stub_chain(:gender_was, :nil?).and_return(true)
        @observer.stub(:remove_from_list).and_return(true)
      end

      it "should_receive remove_from_list for gender" do
        @observer.should_receive(:remove_from_list).with(@user, Sendgrid::SendgridList.without_gender_list_name).and_return(true)
        @observer.send(:manage_gender_list)
      end
    end

    context 'when gender was present before' do
      before do
        @user.stub(:gender_was).and_return(@old_gender)
      end

      it "should not receive remove_from_list" do
        @observer.should_not_receive(:remove_from_list).with(@user, Sendgrid::SendgridList.without_gender_list_name)
        @observer.send(:manage_gender_list)
      end
    end
  end

  describe 'sync_user_properties' do
    before do
      @user.stub(:firstname_changed?).and_return(true)
      @observer.stub(:update_subscription).and_return(true)
      @observer.stub(:add_to_new_and_remove_from_old_list).with(@user, @age_bracket, @old_age_bracket, "age").and_return(true)
      @observer.stub(:add_to_new_and_remove_from_old_list).with(@user, @gender, @old_gender, "gender").and_return(true)
      @user.stub(:age_bracket).and_return(@age_bracket)
      @user.stub(:age_bracket_was).and_return(@old_age_bracket)
      @user.stub(:age_bracket_changed?).and_return(false)
      @user.stub(:gender_changed?).and_return(false)
      @user.stub(:status_changed?).and_return(false)
    end

    context 'when status_changed?' do
      before do
        @user.stub(:status_changed?).and_return(true)
        @job.stub(:update_all_users_list_for_status).and_return(true)
      end

      it "should_receive update_all_users_list_for_status on job" do
        @job.should_receive(:update_all_users_list_for_status).and_return(true)
        @observer.sync_user_properties
      end

      it "should_receive delay on observer" do
        @observer.should_receive(:delay).and_return(@job)
        @observer.sync_user_properties
      end
    end

    context 'when status_changed false' do
      it "should not receive update_all_users_list_for_status on job" do
        @job.should_not_receive(:update_all_users_list_for_status).with(@user)
        @observer.sync_user_properties
      end

      it "should not receive delay on observer" do
        @observer.should_not_receive(:delay)
        @observer.sync_user_properties
      end
    end

    describe 'age bracket changed?' do

      context 'when age_bracket_changed true' do
        before do
          @user.stub(:age_bracket_changed?).and_return(true)
        end

        it "should_receive manage_age_list" do
          @observer.should_receive(:manage_age_list).and_return(true)
        @observer.sync_user_properties
        end

      end

      context 'when age_bracket_changed false' do

        it "should not receive manage_age_list" do
          @observer.should_not_receive(:manage_age_list).with(@user, @age_bracket, @old_age_bracket)
        @observer.sync_user_properties
        end
      end
    end

    describe 'gender changed?' do

      context 'when gender changed true' do
        before do
          @user.stub(:gender_changed?).and_return(true)
        end
        it "should_receive add_to_new_and_remove_from_old_list" do
          @observer.should_receive(:manage_gender_list).and_return(true)
          @observer.sync_user_properties
        end

      end

      context 'when gender_changed false' do
        it "should not receive add_to_new_and_remove_from_old_list" do
          @observer.should_not_receive(:manage_gender_list).with(@user)
          @observer.sync_user_properties
        end
      end
    end

    context "firstname changed or lastname_changed" do
      before do
        @user.stub(:firstname_changed?).and_return(true)
      end

      it "should_receive update_subscription" do
        @observer.should_receive(:update_subscription).and_return(true)
        @observer.sync_user_properties
      end
    end

    context 'when name not changed' do
      before do
        @user.stub(:firstname_changed?).and_return(false)
        @user.stub(:lastname_changed?).and_return(false)
        @user.stub(:age_bracket_changed?).and_return(false)
      end

      it "should not update_subscription" do
        @observer.should_not_receive(:update_subscription).with(@user)
        @observer.sync_user_properties
      end
    end
  end

  describe 'add_to_new_and_remove_from_old_list' do
    before do
      @old_age_bracket = "21-27"
      @old_age_bracket_list = "#{@old_age_bracket} age group Subscribers(test)"
      @user.stub(:age_bracket).and_return(@age_bracket)
      @user.stub(:age_bracket_was).and_return(@old_age_bracket)
      @user.stub(:email_subscription).and_return(@subscriptions)
      @subscriptions.stub(:enabled).and_return([])
      @observer.stub(:get_list_name).with("age", @old_age_bracket).and_return(@old_age_bracket_list)
      @observer.stub(:get_list_name).with("age", @age_bracket).and_return(@list)
    end

    it "should_receive email_subscription on user" do
      @user.should_receive(:email_subscription).and_return(@subscriptions)
      @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
    end

    it "should_receive enabled on subscriptions" do
      @subscriptions.should_receive(:enabled).and_return([])
      @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
    end

    context 'when subscription present' do
      before do
        @user.stub(:email_subscription).and_return(@subscriptions)
        @subscriptions.stub(:enabled).and_return(@subscriptions)
      end

      it "should_receive get_list_name for old age" do
        @observer.should_receive(:get_list_name).with("age", @old_age_bracket).and_return(@old_age_bracket_list)
        @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
      end

      it "should_receive get_list_name for new age" do
        @observer.should_receive(:get_list_name).with("age", @age_bracket).and_return(@list)
        @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
      end

      context 'delete_from_list' do
        it "should_receive delay on sendgrid" do
          Sendgrid::SendgridList.should_receive(:delay).and_return(@job)
          @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
        end

        pending "should_receive delete_from_list on delayed job" do
          @job.should_receive(:delete_from_list).with(@old_age_bracket_list, @subscription.email).and_return(true)
          @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
        end 
      end

      context 'add_to_list' do
        it "should_receive delay on sendgrid" do
          Sendgrid::SendgridList.should_receive(:delay).and_return(@job)
          @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
        end

        it "should_receive add_to_list on delayed job" do
          @job.should_receive(:add_to_list).with(@list, [@subscription]).and_return(true)
          @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
        end 
      end
    end


    context 'when subscription not present' do
      before do
        @user.stub(:email_subscription).and_return(@subscriptions)
        @subscriptions.stub(:enabled).and_return([])
      end

      context 'delete_from_list' do
        it "should not receive delay on sendgrid" do
          Sendgrid::SendgridList.should_not_receive(:delay)
          @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
        end

        it "should not receive delete_from_list on delayed job" do
          @job.should_not_receive(:delete_from_list).with(@old_age_bracket_list, @subscription.email)
          @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
        end 
      end

      context 'add_to_list' do
        it "should not receive delay on sendgrid" do
          Sendgrid::SendgridList.should_not_receive(:delay)
          @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
        end

        it "should not receive add_to_list on delayed job" do
          @job.should_not_receive(:add_to_list).with(@list, [@subscription])
          @observer.send(:add_to_new_and_remove_from_old_list, @user, @age_bracket, @old_age_bracket, "age")      
        end 
      end
    end
  end
  
  describe 'update_subscription' do
    before do
      @job.stub(:update_all_users_list).and_return(true)
      @job.stub(:update_list).with(@subscription, Sendgrid::SendgridList.all_subscriber_list_name).and_return(true)
      @job.stub(:update_list).with(@subscription, @list).and_return(true)
      @job.stub(:update_list).and_return(true)
      @observer.stub(:update_subscription_for_state).with(@user).and_return(true)
      @user.stub(:email_subscription).and_return(@subscriptions)
      @subscriptions.stub(:enabled).and_return(@subscriptions)
      @user.stub(:age_bracket?).and_return(true)
      @subscription.stub(:state_name).and_return("list")
      @user.stub(:gender?).and_return(true)
      Sendgrid::SendgridList.stub(:without_age_list_name).and_return("abc")
    end

    it "should_receive update_subscription_for_state" do
      @observer.should_receive(:update_subscription_for_state).with(@user).and_return(true)
      @observer.send(:update_subscription)
    end

    it "should receive delay on observer" do
      @observer.should_receive(:delay).and_return(@job)
      @observer.send(:update_subscription)
    end

    it "should_receive update_all_users_list on delay job" do
      @job.should_receive(:update_all_users_list).and_return(true)
      @observer.send(:update_subscription)
    end

    context "subscription present" do
      context 'when age_bracket present' do
        it "should_receive update_list for age group subscription" do
          @job.should_receive(:update_list).with(@subscription, @list).and_return(true)
          @observer.send(:update_subscription)
        end

        it "should not receive update_list for no age group list" do
          @job.should_not_receive(:update_list).with(@subscription, "abc")
          @observer.send(:update_subscription)
        end
      end


      context 'when age_bracket not present' do
        before do
          @user.stub(:age_bracket?).and_return(false)
        end

        it "observer should receive delay" do
          @observer.should_receive(:delay).and_return(@job)
          @observer.send(:update_subscription)
        end

        it "should not receive update_list for age group subscription" do
          @job.should_not_receive(:update_list).with(@subscription, Sendgrid::SendgridList.age_group_list_name(@age_bracket))
          @observer.send(:update_subscription)
        end

        it "should receive update_list for no age group list" do
          @job.should_receive(:update_list).with(@subscription, Sendgrid::SendgridList.without_age_list_name).and_return(true)
          @observer.send(:update_subscription)
        end
      end

      it "should_receive update_list for gender subscription" do
        @job.should_receive(:update_list).with(@subscription, @gender_list).and_return(true)
        @observer.send(:update_subscription)
      end

      it "should_receive update_list for ALL_SUBSCRIBER" do
        @job.should_receive(:update_list).with(@subscription, Sendgrid::SendgridList.all_subscriber_list_name).and_return(true)
        @observer.send(:update_subscription)
      end
    end

    context "subscription not present" do
      before do
        @user.stub(:email_subscription).and_return(@subscriptions)
        @subscriptions.stub(:enabled).and_return([])
      end

      it "should not receive update_list on any" do
        @observer.should_not_receive(:update_list)
        @observer.send(:update_subscription)
      end
    end
  end

  describe 'update_subscription_for_state' do
    before do
      #@subscription1 = mock_model(EmailSubscription)
      @subscription1 = EmailSubscription.new('a@b.c')
      @subscriptions = [@subscription, @subscription1]
      @user.stub(:email_subscription).and_return(@subscriptions)
      @subscriptions.stub(:enabled).and_return(@subscriptions)
      @subscription.stub(:state_name).and_return("list")
      @subscription1.stub(:state_name).and_return("list")
      @job.stub(:update_list).and_return(true)
    end

    it "subscription should_receive list_name_by_state twice" do
      Sendgrid::SendgridList.should_receive(:list_name_by_state).with(@subscription.state_name)
      Sendgrid::SendgridList.should_receive(:list_name_by_state).with(@subscription1.state_name)
      @observer.send(:update_subscription_for_state, @user)
    end

    it "should_receive update_list twice" do
      @job.should_receive(:update_list).twice.and_return(true)
      @observer.send(:update_subscription_for_state, @user)
    end

    it "observer should receive delay" do
      @observer.should_receive(:delay).and_return(@job)
      @observer.send(:update_subscription_for_state, @user)
    end
  end


  describe 'remove_from_list' do
    before do
      @user.stub(:email_subscription).and_return(@subscriptions)
      @subscriptions.stub(:enabled).and_return(@subscriptions)
    end

    it "user should_receive email_subscription" do
      @user.should_receive(:email_subscription).and_return(@subscriptions)
      @observer.send(:remove_from_list, @user, "list")
    end

    it "subscriptions should_receive enabled" do
      @subscriptions.should_receive(:enabled).and_return(@subscriptions)
      @observer.send(:remove_from_list, @user, "list")
    end

    context 'when subscription present' do
      it "should receive delay on sendgrid" do
        Sendgrid::SendgridList.should_receive(:delay).and_return(@job)
        @observer.send(:remove_from_list, @user, "list")
      end
      
      it "should receive delete_from_list on delayed job object" do
        @job.should_receive(:delete_from_list).with("list", @subscription.email).and_return(true)
        @observer.send(:remove_from_list, @user, "list")
      end
    end

    context 'when subscription not present' do
      before do
        @user.stub(:email_subscription).and_return(@subscriptions)
        @subscriptions.stub(:enabled).and_return([])
      end

      it "should not receive delay on sendgrid" do
        Sendgrid::SendgridList.should_not_receive(:delay)
        @observer.send(:remove_from_list, @user, "list")
      end
      
      it "should not receive delete_from_list on delayed job object" do
        @job.should_not_receive(:delete_from_list).with("list", @subscription.email)
        @observer.send(:remove_from_list, @user, "list")
      end
    end
  end

  describe 'get_list_name' do
    context 'when age ' do
      it "should_receive age_group_list_name" do
        Sendgrid::SendgridList.should_receive(:age_group_list_name).with("new").and_return(true)
        @observer.send(:get_list_name, "age", "new")
      end
    end

    context 'when gender' do
      it "should_receive gender_based_list" do
        Sendgrid::SendgridList.should_receive(:gender_based_list).with("new").and_return(true)
        @observer.send(:get_list_name, "gender", "new")
      end
    end
  end

  describe 'list_name_for_age_group' do
    context 'when age_bracket? true' do
      before do
        @user.stub(:age_bracket?).and_return(true)
      end

      it "should_receive age_group_list_name on sendgrid" do
        Sendgrid::SendgridList.should_receive(:age_group_list_name).with(@age_bracket).and_return(true)
        @observer.send(:list_name_for_age_group, @user)
      end
    end

    context 'when age_bracket? false' do
      before do
        @user.stub(:age_bracket?).and_return(false)
      end

      it "should_receive age_group_list_name on sendgrid" do
        Sendgrid::SendgridList.should_receive(:without_age_list_name).and_return(true)
        @observer.send(:list_name_for_age_group, @user)
      end
    end
  end

  describe 'list_name_for_gender_group' do
    context 'when gender? true' do
      before do
        @user.stub(:gender?).and_return(true)
      end

      it "should_receive age_group_list_name on sendgrid" do
        Sendgrid::SendgridList.should_receive(:gender_based_list).with(@gender).and_return(true)
        @observer.send(:list_name_for_gender_group, @user)
      end
    end

    context 'when gender? false' do
      before do
        @user.stub(:gender?).and_return(false)
      end

      it "should_receive age_group_list_name on sendgrid" do
        Sendgrid::SendgridList.should_receive(:without_gender_list_name).and_return(true)
        @observer.send(:list_name_for_gender_group, @user)
      end
    end
  end


  describe 'update_list' do
    before do
      Sendgrid::SendgridList.stub(:delete_from_list).and_return(true)
      Sendgrid::SendgridList.stub(:add_to_list).and_return(true)
    end

    it "should receive delete_from_list on sendgrid" do
      Sendgrid::SendgridList.should_receive(:delete_from_list).and_return(true)
      @observer.send(:update_list, @subscription, "list")
    end

    it "should receive add_to_list on sendgrid" do
      Sendgrid::SendgridList.should_receive(:add_to_list).and_return(true)
      @observer.send(:update_list, @subscription, "list")
    end
    
  end
  
end
