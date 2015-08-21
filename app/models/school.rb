## SCHEMA
#  name      (string)
#  lessons   (has many)
class School < ActiveRecord::Base
  has_many :lessons
  has_many :users, -> { uniq }, through: :lessons

  validates :name, uniqueness: true, presence: true

  def to_s
    name
  end
end
