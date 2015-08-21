class AddTypeToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :respondable_type, :string
  end
end
