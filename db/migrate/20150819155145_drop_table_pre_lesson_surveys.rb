class DropTablePreLessonSurveys < ActiveRecord::Migration
  def change
    drop_table :pre_lesson_surveys
  end
end
