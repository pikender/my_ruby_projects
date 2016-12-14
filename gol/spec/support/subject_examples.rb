shared_examples "my observed" do 
  let(:observed) {described_class.new}
  
  it "should initialize observers array to hold observers instances" do
    observed.should respond_to(:observers)
    observed.observers.should be_kind_of(Array)
    observed.observers.should be_empty
  end

  context "Add/Remove Obervers" do 
    let(:total_observers) {observer_instances.size} 
    let(:first_observer) {observer_instances.first} 
    before(:each) do
      observer_instances.each do |observer_instance|
        observed.add_observer(observer_instance)
      end
    end

    it "should be able to add observers" do
      observed.observers.should_not be_empty
      observed.observers.should have(total_observers).items
      observed.observers.should include(first_observer)
      observer_instances.each do |observer_instance|
        observed.observers.should include(observer_instance)
      end
    end

    it "should be able to delete observers" do
      observed.observers.should_not be_empty
      observed.observers.should have(total_observers).items
      observed.delete_observer(first_observer)
      observed.observers.should have(total_observers - 1).items
      observed.observers.should_not include(first_observer)
    end

    it "should notify observers" do
      observed.notify_observers.should eq(observer_instances)
    end
  end
end
