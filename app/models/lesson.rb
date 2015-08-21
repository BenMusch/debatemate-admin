## SCHEMA
#  date        (date)
#  school_id   (integer)
#  goals       (has-many)
#  users       (many-to-many through goals)

class Lesson < ActiveRecord::Base
  belongs_to :school
  has_many   :users, through: :goals
  has_many   :goals, dependent: :destroy

  validates_presence_of :date, :school_id
  validates_uniqueness_of :date, scope: :school_id

  accepts_nested_attributes_for :goals

  # Was this lesson given by the passed user?
  def given_by?(user)
    self.users.map(&:id).include?(user.id)
  end

  # Formaes as 'Date: School Name'
  def to_s
    date.to_formatted_s(:short) + ": " + school.name
  end
end
