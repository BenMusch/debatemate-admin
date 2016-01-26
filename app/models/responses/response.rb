class Response < ActiveRecord::Base
  attr_accessible :type, response_field
  attr_reader     :type

  belongs_to :question
  belongs_to :user

  before_validation :set_type

  private

  def set_type
    @type = self.class.name
  end
end
