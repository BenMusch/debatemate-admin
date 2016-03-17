class OptionTemplate
  include Mongoid::Document

  embedded_in :response_template
end
