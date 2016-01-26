class TextResponse < Response

  def set_value(value)
    if value.is_a? string
      this.update_attribute(:text_value, value)
    else
      raise ArgumentError
    end
  end

  def answered?
    self.text_value != nil
  end

  def response_field
    :text_value
  end

  def render(str)
    "<% #{str}.text_area response_field %>".html_safe
  end
end
