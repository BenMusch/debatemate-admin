class AddGoalsToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :goals, :text
  end
end
