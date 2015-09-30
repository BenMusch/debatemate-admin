class AddDaysToUsers < ActiveRecord::Migration
  def change
    add_column :users, :monday, :boolean
    add_column :users, :tuesday, :boolean
    add_column :users, :wednesday, :boolean
    add_column :users, :thursday, :boolean
    add_column :users, :friday, :boolean
  end
end
