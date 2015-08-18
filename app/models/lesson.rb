## SCHEMA
#  date        (datetime)
#  school_id   (integer)

class Lesson < ActiveRecord::Base
  belongs_to :school
  has_many   :pre_lesson_surveys
  has_many   :users, -> { uniq }, through: :pre_lesson_surveys

  # Was this lesson given by the passed user?
  def given_by?(user)
    self.users.map(&:id).include?(user.id)
  end
end
