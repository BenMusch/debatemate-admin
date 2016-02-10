class Goal
  include Mongoid::Document

  field :text, type: String

  belongs_to :lesson
  belongs_to :user

  validates_presence_of :text
end
