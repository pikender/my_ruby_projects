require 'tic_tac_slideshare_helper.rb'

tt = TicTacGrid.new("XOXOXOXOX")
tt.find_row_straights
tt.find_col_straights
tt.find_diagonals

#char_oxa = ["X", "O"]
#char_xoa = ["O", "X"]
#in_oxa = "---------"
#in_xoa = "---------"
#1.upto(9) do |i|
#  rem_i = (i % 2)
#  in_oxa[i - 1] = char_oxa[rem_i]
#  in_xoa[i - 1] = char_xoa[rem_i]
#  if i > 10
#    [in_oxa, in_xoa].each do |in_oxoa|
#      in_oxoa.perm.each do |permt|    
#        tt = TicTacGrid.new(permt)
#        p permt

#        if tt.win?('X')   
#          p "Player X WINS"
#        elsif tt.win?('O')
#          p "Player O WINS"
#        elsif tt.empty_cell_present?
#          p "Continue Playing"
#        else
#          p "Stalemate"  
#        end 
#      end
#    end
#  end
#end

