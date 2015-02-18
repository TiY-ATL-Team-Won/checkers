class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
    	t.text :board
    	t.integer :turn_count
    	t.boolean :finished
    	t.string :player1_email
    	t.string :player2_email
    	t.integer :players_count
    end
  end
end
