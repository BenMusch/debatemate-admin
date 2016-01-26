class CreateDependencies < ActiveRecord::Migration
  def change
    create_table :dependencies do |t|
      t.references :question, index: true, foreign_key: true
      t.references :response, index: true, foreign_key: true
      t.boolean :trigger_value

      t.timestamps null: false
    end
  end
end
