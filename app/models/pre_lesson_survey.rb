## SCHEMA
#  lesson_id  (integer)
#  user_id    (integer)
#  goals      (text)

class PreLessonSurvey < ActiveRecord::Base
  attr_accessor :school, :date

  belongs_to :lesson
  belongs_to :user

  validates_presence_of :goals, :school, :date

  before_save :set_lesson

  def to_s
    "PreLessonSurvey: " + self.lesson + " " + self.user
  end

  private

    # Sets the lesson that this survey belongs to equal to a new lesson or the
    # one that exists on the specified date at the specified school
    def set_lesson
      if school && date
        self.lesson = Lesson.find_by_or_create!(school: self.school,
                                                date:   self.date)
      end
    end
end
