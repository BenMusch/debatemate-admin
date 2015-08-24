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

  scope :upcoming,  -> { where('DATE >= ?', Date.today) }
  scope :completed, -> { where('DATE < ?', Date.today) }

  # Was this lesson given by the passed user?
  def given_by?(user)
    self.users.map(&:id).include?(user.id)
  end

  # Formats as 'Date: School Name'
  def to_s
    date.to_formatted_s(:short) + ": " + school.name
  end

  # All of the lessons on or after today
  def Lesson.upcoming
    Lesson.where('DATE >= ?', Date.today).order(:date)
  end

  # All of the lessons before today
  def Lesson.completed
    Lesson.where('DATE < ?', Date.today).order(:date)
  end

  # Returns a string of all of the mentors, separated by commas
  def mentor_list
    users.map(&:name).join(", ")
  end

  # Makes a string of the names of the lesson that shows up on the index view
  def row_name(admin)
    admin ? names = " (#{mentor_list})"  : names = ''
    to_s + names
  end
end
