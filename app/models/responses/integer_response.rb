class IntegerResponse < Response

  def set_value(value)
    if value.is_a? Integer
      self.update_attribute(:integer_value, value)
    else
      raise ArgumentError
    end
  end

  def answered?
    self.integer_value != nil
  end

  def response_field
    :integer_value
  end

  def render(str)
    "<%= #{str}.integer_field #{response_field} %>".html_safe
  end
end
