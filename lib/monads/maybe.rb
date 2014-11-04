class Maybe < Monad
  def self.from_value(value)
    new(value)
  end

  def initialize(value)
    @value = value
  end

  def unwrap
    @value
  end

  def and_then
    return self if @value.nil?

    new_maybe = yield @value
    check_type(new_maybe)
    new_maybe
  end

  def method_missing(*args, &block)
    within do |value|
      value.public_send(*args, &block)
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    super || and_then do |value|
      return value.respond_to?(method_name, include_private)
    end
  end
end
