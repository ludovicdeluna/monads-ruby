class Maybe < Monad
  def initialize(value)
    @value = value
  end

  def and_then
    return self if @value.nil?
    new_value = yield @value
    self.class.from_value(new_value)
  end

  def unwrap
    @value
  end
end

module Kernel
  def Maybe(value)
    Maybe.new(value)
  end
end
