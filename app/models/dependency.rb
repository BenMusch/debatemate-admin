# Represents a question whose validation depends on the response to another
# question
class Dependency < ActiveRecord::Base
  belongs_to :question
  belongs_to :response
end
