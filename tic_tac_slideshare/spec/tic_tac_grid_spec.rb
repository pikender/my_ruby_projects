require 'spec_helper'

describe TicTacGrid do  
  it_should_behave_like "my_string_permutation"

  let(:tic_tac_grid) {TicTacGrid.new("XOXOOXXXO")}

  let(:tic_tac_grid_incomplete) {TicTacGrid.new("XOX-")}
  let(:tic_tac_grid_complete) {TicTacGrid.new("XOXO")}

  let(:tic_tac_grid_continue_play) {TicTacGrid.new("XX-OOX---")}

  let(:tic_tac_grid_stalemate) {TicTacGrid.new("XOXOOXXXO")}

  let(:tic_tac_grid_X_first_row_st) {TicTacGrid.new("XXXOO----")}
  let(:tic_tac_grid_X_second_row_st) {TicTacGrid.new("---XXXOO-")}
  let(:tic_tac_grid_X_third_row_st) {TicTacGrid.new("OO----XXX")}

  let(:tic_tac_grid_X_first_col_st) {TicTacGrid.new("X--X-OXO-")}
  let(:tic_tac_grid_X_second_col_st) {TicTacGrid.new("-X-OX-OX-")}
  let(:tic_tac_grid_X_third_col_st) {TicTacGrid.new("OOX--X--X")}

  let(:tic_tac_grid_X_straight_diagonal) {TicTacGrid.new("X---XO-OX")}
  let(:tic_tac_grid_X_opposite_diagonal) {TicTacGrid.new("--XOX-XO-")}

  it 'should raise error and inform for invalid characters (other than X, O, -) in grid string ' do
    expect {TicTacGrid.new}.to raise_error(ArgumentError)
    expect {TicTacGrid.new("XO=")}.to raise_error(RuntimeError, /Invalid Letter \(=\) Present/)
    expect {TicTacGrid.new("XO-")}.to_not raise_error(RuntimeError, /Not a perfect square 1 * 1 NOT EQUAL TO 3/)
    expect {TicTacGrid.new("XO--")}.to_not raise_error(RuntimeError)
  end

  it 'should inform if grid has empty cells' do
    tic_tac_grid_stalemate.should_not be_empty_cell_present

    tic_tac_grid_incomplete.should be_empty_cell_present
    tic_tac_grid_complete.should_not be_empty_cell_present
  end

  it 'should find Correct Straight Rows ' do
    res_row_straights = tic_tac_grid.find_row_straights
    res_row_straights.should have(3).items

    [[0,1,2], [3,4,5], [6,7,8]].each do |row_st|
      res_row_straights.should include(row_st)
    end
  end

  it 'should find Correct Straight Cols ' do
    res_col_straights = tic_tac_grid.find_col_straights
    res_col_straights.should have(3).items
    
    [[0,3,6], [1,4,7], [2,5,8]].each do |col_st|
      res_col_straights.should include(col_st)
    end
  end


  it 'should find Correct Diagonals ' do
    res_diagonals = tic_tac_grid.find_diagonals
    res_diagonals.should have(2).items

    [[0,4,8], [2,4,6]].each do |diag|
      res_diagonals.should include(diag)
    end
  end

  it 'should guide if X has Straight Row' do
    tic_tac_grid_continue_play.should_not be_rows_match('X')
    tic_tac_grid_stalemate.should_not be_rows_match('X')

    tic_tac_grid_X_first_row_st.should be_rows_match('X')
    tic_tac_grid_X_second_row_st.should be_rows_match('X')
    tic_tac_grid_X_third_row_st.should be_rows_match('X')
  end

  it 'should guide if X has Straight Cols' do
    tic_tac_grid_continue_play.should_not be_cols_match('X')
    tic_tac_grid_stalemate.should_not be_cols_match('X')

    tic_tac_grid_X_first_col_st.should be_cols_match('X')
    tic_tac_grid_X_second_col_st.should be_cols_match('X')
    tic_tac_grid_X_third_col_st.should be_cols_match('X')
  end

  it 'should guide if X has Diagonals' do
    tic_tac_grid_continue_play.should_not be_diagonals_match('X')
    tic_tac_grid_stalemate.should_not be_diagonals_match('X')

    tic_tac_grid_X_straight_diagonal.should be_diagonals_match('X')
    tic_tac_grid_X_opposite_diagonal.should be_diagonals_match('X')
  end

  context "Declare Winner" do
    it 'should declare X as winner if X has Straight Row' do
      tic_tac_grid_continue_play.should_not be_win('X')
      tic_tac_grid_stalemate.should_not be_win('X')

      tic_tac_grid_X_first_row_st.should be_win('X')
      tic_tac_grid_X_second_row_st.should be_win('X')
      tic_tac_grid_X_third_row_st.should be_win('X')
    end

    it 'should declare X as winner if X has Straight Cols' do
      tic_tac_grid_continue_play.should_not be_win('X')
      tic_tac_grid_stalemate.should_not be_win('X')

      tic_tac_grid_X_first_col_st.should be_win('X')
      tic_tac_grid_X_second_col_st.should be_win('X')
      tic_tac_grid_X_third_col_st.should be_win('X')
    end

    it 'should declare X as winner if X has Diagonals' do
      tic_tac_grid_continue_play.should_not be_win('X')
      tic_tac_grid_stalemate.should_not be_win('X')

      tic_tac_grid_X_straight_diagonal.should be_win('X')
      tic_tac_grid_X_opposite_diagonal.should be_win('X')
    end
  end

  it 'should inform to continue play if neither X nor Y is winner and there are empty cells to play' do
    tic_tac_grid_stalemate.should_not be_continue_playing

    tic_tac_grid_continue_play.should be_continue_playing
    tic_tac_grid_X_opposite_diagonal.should_not be_continue_playing
  end

  it 'should inform stalemate if neither X nor Y is winner and there are no empty cells to play' do
    tic_tac_grid_stalemate.should be_stalemate
    tic_tac_grid_continue_play.should_not be_stalemate
    tic_tac_grid_X_opposite_diagonal.should_not be_stalemate
  end

end  
