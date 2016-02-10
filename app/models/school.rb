class School
  include Mongoid::Document

  field :name, type: String

  has_many :lessons

  validates :name, uniqueness: true, presence: true

  def to_s
    name
  end

  def users
    lessons.map(&:users).flatten.uniq
  end
end
