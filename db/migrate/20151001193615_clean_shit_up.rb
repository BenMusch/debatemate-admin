class CleanShitUp < ActiveRecord::Migration
  def change
    change_column :users, :monday, :boolean, default: false
    change_column :users, :tuesday, :boolean, default: false
    change_column :users, :wednesday, :boolean, default: false
    change_column :users, :thursday, :boolean, default: false
    change_column :users, :friday, :boolean, default: false
    change_column :users, :phone, :integer, limit: 10
  end
end
