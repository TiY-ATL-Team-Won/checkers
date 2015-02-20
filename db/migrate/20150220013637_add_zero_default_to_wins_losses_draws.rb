class AddZeroDefaultToWinsLossesDraws < ActiveRecord::Migration
  def change
  	change_column_default :users, :wins, 0
  	change_column_default :users, :losses, 0
  	change_column_default :users, :draws, 0
  end
end
