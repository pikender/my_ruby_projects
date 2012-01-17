require 'spec_helper'

describe Coordinates do
  let(:coordinates) {Coordinates.new(0,0)}

  it "should respond to x and y" do
     coordinates.should respond_to(:x)
     coordinates.should respond_to(:y)

     coordinates.x.should eq(0)
     coordinates.y.should eq(0)
  end  
end
