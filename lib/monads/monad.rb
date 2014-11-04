class Monad
  def within
    and_then do |value|
      new_value = yield value
      self.class.from_value(new_value)
    end
  end

  def check_type(maybe)
    return if maybe.is_a?(self.class)

    msg = "Expected an instance of #{ self.class }, got #{ maybe.class }"
    fail TypeError, msg
  end
end
