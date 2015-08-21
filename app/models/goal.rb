## SCHEMA
#  text     (text)
#  lesson   (belongs to)
#  user     (belongs to)
class Goal < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :user

  validates_presence_of :text
end
