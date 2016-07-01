class ResponseTemplate
  include Mongoid::Document

  embedded_in :question_template
end
