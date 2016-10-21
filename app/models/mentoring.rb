class Mentoring
  include Mongoid::Documents

  field :confirmed, type: Boolean

  has_one :pre_lesson_survey, class: Survey
  has_one :post_lesson_survey, class: Survey
end
