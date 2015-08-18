class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.datetime :date
      t.references :school, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
