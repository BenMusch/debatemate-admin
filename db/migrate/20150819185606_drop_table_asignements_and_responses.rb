class DropTableAsignementsAndResponses < ActiveRecord::Migration
  def change
    drop_table :assignments
    drop_table :responses
  end
end
