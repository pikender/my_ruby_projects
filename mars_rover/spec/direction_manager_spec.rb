require 'spec_helper'

describe DirectionManager do
  let(:direction_manager) {DirectionManager.instance}

  it 'should return correct direction for "N"' do
    DirectionManager.get_direction("N").should be_an_instance_of(NorthDirection)
  end

  it 'should return correct direction for "E"' do
    DirectionManager.get_direction("E").should be_an_instance_of(EastDirection)
  end

  it 'should return correct direction for "W"' do
    DirectionManager.get_direction("W").should be_an_instance_of(WestDirection)
  end

  it 'should return correct direction for "S"' do
    DirectionManager.get_direction("S").should be_an_instance_of(SouthDirection)
  end

  it 'should face_north and return NorthDirection' do
    DirectionManager.face_north.should be_an_instance_of(NorthDirection)
  end

  it 'should face_east and return EastDirection' do
    DirectionManager.face_east.should be_an_instance_of(EastDirection)
  end

  it 'should face_west and return WestDirection' do
    DirectionManager.face_west.should be_an_instance_of(WestDirection)
  end

  it 'should face_south and return SouthDirection' do
    DirectionManager.face_south.should be_an_instance_of(SouthDirection)
  end

end
