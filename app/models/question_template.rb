class QuestionTemplate
  include Mongoid::Document

  embedded_in :template
end
