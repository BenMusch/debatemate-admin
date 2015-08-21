class ChangeDatetimeToDate < ActiveRecord::Migration
  def change
    change_column :lessons, :date, :date
  end
end
