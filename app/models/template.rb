class Template
  include Mongoid::Document

  embeds_many :question_templates
end
