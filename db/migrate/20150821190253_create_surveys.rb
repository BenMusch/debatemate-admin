class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.references :user, index: true, foreign_key: true
      t.references :lesson, index: true, foreign_key: true
      t.integer :attendance
      t.integer :week_number
      t.boolean :teacher_attended_whole_lesson

      t.timestamps null: false
    end
  end
end
