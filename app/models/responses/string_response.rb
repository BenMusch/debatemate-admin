class StringResponse < Response

  def set_value(value)
    if value.is_a? String
      self.update_attribute(:string_value, value)
    else
      raise ArgumentError
    end
  end

  def answered?
    self.string_response != nil
  end

  def response_field
    :string_value
  end

  def render(str)
    "<%= #{str}.text_field #{response_field} %>".html_safe
  end
end
