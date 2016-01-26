class ChangeTypeName < ActiveRecord::Migration
  def change
    rename_column :responses, :response_type, :type
  end
end
