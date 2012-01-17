require 'spec_helper'
require 'yaml'

describe Ticker do
  let(:ticker_inst) {Ticker.new}  

  let(:rule1) {Rule1LonelyOneOrNoLiveNeighbour.new}   

  let(:rule2) {Rule2CrowdedFourOrMoreLiveNeighbours.new}   

  let(:rule3) {Rule3Unchanged2Or3LiveNeighbours.new}   

  let(:rule4) {Rule4BackFromDeadExactly3LiveNeighbours.new}  

  let(:grid_pattern) {Grid.new}

  let(:next_gen_grid_pattern) {Grid.new}

  it "should initialize rules as an empty Array" do
    ticker_inst.rules.should be_an_instance_of(Array)
    ticker_inst.rules.should be_empty
  end

  it "should allow addition (<<) of rules in the grid" do    
    ticker_inst << rule1
    ticker_inst.rules.should_not be_empty
    ticker_inst.rules.first.should be_an_instance_of(Rule1LonelyOneOrNoLiveNeighbour)
    
    ticker_inst.remove_rule(rule1)
    ticker_inst.rules.should be_empty
  end

  context "Call tick to show next generationa as per all 4 rules" do    
    before(:each) do
      ticker_inst << rule1
      ticker_inst << rule2
      ticker_inst << rule3
      ticker_inst << rule4

      @allowed_patterns = YAML.load_file("lib/yaml_grids/grid.yml")
    end

    it "for Block Pattern" do     
      ref_output_pattern = @allowed_patterns["block_pattern"]["output"]

      output_pattern_after_tick = compare_next_gen_output("block_pattern")

      output_pattern_after_tick.size.should eq(ref_output_pattern.size)
      output_pattern_after_tick.each do |live_cell_position|
        ref_output_pattern.should include(live_cell_position)
      end
    end

    it "for Boat Pattern" do     
      ref_output_pattern = @allowed_patterns["boat_pattern"]["output"]

      output_pattern_after_tick = compare_next_gen_output("boat_pattern")

      output_pattern_after_tick.size.should eq(ref_output_pattern.size)
      output_pattern_after_tick.each do |live_cell_position|
        ref_output_pattern.should include(live_cell_position)
      end
    end


    it "for Blinker Pattern" do     
      ref_output_pattern = @allowed_patterns["blinker_pattern"]["output"]

      output_pattern_after_tick = compare_next_gen_output("blinker_pattern")

      output_pattern_after_tick.size.should eq(ref_output_pattern.size)
      output_pattern_after_tick.each do |live_cell_position|
        ref_output_pattern.should include(live_cell_position)
      end
    end


    it "for Toad Pattern" do     
      ref_output_pattern = @allowed_patterns["toad_pattern"]["output"]

      output_pattern_after_tick = compare_next_gen_output("toad_pattern")

      output_pattern_after_tick.size.should eq(ref_output_pattern.size)
      output_pattern_after_tick.each do |live_cell_position|
        ref_output_pattern.should include(live_cell_position)
      end
    end

    def compare_next_gen_output(supplied_pattern)
      grid_live_cells = @allowed_patterns[supplied_pattern]["input"]

      grid_live_cells.each do |grid_pos_xy|
        grid_pattern << Cell.new(grid_pos_xy.first,grid_pos_xy.last)  
      end

      alive_cells_now = grid_pattern.cells

      ticker_inst.tick(grid_pattern, next_gen_grid_pattern)

      compare_next_gen_array = []
      next_gen_grid_pattern.cells.each do |next_gen_cells|
        compare_next_gen_array << [next_gen_cells.x, next_gen_cells.y]
      end

      compare_next_gen_array
    end
  end
end
