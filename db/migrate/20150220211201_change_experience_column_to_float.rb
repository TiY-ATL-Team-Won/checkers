class ChangeExperienceColumnToFloat < ActiveRecord::Migration
  def change
    change_column :users, :experience, :float
  end
end
