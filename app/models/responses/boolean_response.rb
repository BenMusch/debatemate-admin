class BooleanResponse < Response

  def set_value(value)
    if value.is_a? Boolean
      self.update_attribute(:boolean_value, value)
    else
      raise ArgumentError
    end
  end

  def answered?
    self.boolean_value != nil
  end

  def response_field
    :boolean_value
  end

  def render(str)
    "<%= #{str}.check_box #{response_field}, {}, true, false %>".html_safe
  end
end
