class RemoveFieldsFromSurveys < ActiveRecord::Migration
  def change
    remove_column :surveys, :attendance
    remove_column :surveys, :week_number
    remove_column :surveys, :teacher_attended_whole_lesson
  end
end
