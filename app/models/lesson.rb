class Lesson
  include Mongoid::Document

  field :date, type: Date

  belongs_to :school
  has_many :goals
  has_and_belongs_to_many :users

  validates_presence_of :date

  accepts_nested_attributes_for :goals

  scope :upcoming, ->{ where(:date.gte => Date.today).order(:date.asc) }
  scope :completed, ->{ where(:date.lt => Date.today).order(:date.desc) }

  def given_by?(user)
    self.users.map(&:id).include?(user.id)
  end

  def to_s
    date.to_formatted_s(:short) + ": " + school.name
  end

  def delete_goals
    goals.each { |goal| goal.destroy unless users_ids.include? goal.user_id }
  end
end
