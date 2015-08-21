class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.text :text
      t.references :lesson, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
