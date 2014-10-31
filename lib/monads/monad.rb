class Monad
  def self.from_value(value)
    return value if value.is_a?(self)
    new(value)
  end

  def method_missing(*args, &block)
    and_then do |value|
      value.public_send(*args, &block)
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    super || and_then do |value|
      return value.respond_to?(method_name, include_private)
    end
  end
end
