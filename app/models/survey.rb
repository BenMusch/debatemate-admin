class Survey < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson
  has_many :questions
  has_many :response, through: :questions
end
