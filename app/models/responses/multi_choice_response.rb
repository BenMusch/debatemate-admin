class MultiChoiceResponse < StringResponse
  has_many :choices

  def render(str)
    code = ''
    self.choices.each do |choice|
      code += "<%= #{str}.radio_button #{response_field}, #{choice} %>"
    end
    code.html_safe
  end
end
