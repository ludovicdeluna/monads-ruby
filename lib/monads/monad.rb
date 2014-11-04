module Monads
  # Common superclass for all monads. Provides a +within+ method for easy
  # chaining.
  #
  # @example
  #   include Monads
  #
  #   Maybe.new('Hello world').within do |string|
  #     string.upcase
  #   end.within do |string|
  #     string.reverse
  #   end.unwrap # => 'DLROW OLLEH'
  #
  #   Maybe.new('Hello world').within do |string|
  #     nil
  #   end.within do |string|
  #     string.reverse
  #   end.unwrap # => nil
  #
  #   eventually = Eventually.from_value('Hello world').within do |string|
  #     string.upcase
  #   end.within do |string|
  #     string.reverse
  #   end
  #
  #   value = eventually.run do |string|
  #     "Got result: #{ string }"
  #   end # => 'Got result: DLROW OLLEH'
  class Monad
    # Chain with another Maybe monad. The yielded block does not need to
    # return a monad.
    #
    # @example
    #   Maybe.new('Hello world').within do |string|
    #     string.upcase
    #   end.within do |string|
    #     string.reverse
    #   end.unwrap # => 'DLROW OLLEH'
    #
    #   Maybe.new('Hello world').within do |string|
    #     nil
    #   end.within do |string|
    #     string.reverse
    #   end.unwrap # => nil
    #
    #   eventually = Eventually.from_value('Hello world').within do |string|
    #     string.upcase
    #   end.within do |string|
    #     string.reverse
    #   end
    #
    #   value = eventually.run do |string|
    #     "Got result: #{ string }"
    #   end # => 'Got result: DLROW OLLEH'
    #
    # @yieldparam value [Object] Unwrapped value goes in the block.
    # @yieldreturn      [Object] Can return anything.
    #
    # @return [Monad] New value wrapped in a Monad.
    def within
      and_then do |value|
        new_value = yield value
        self.class.from_value(new_value)
      end
    end

    protected

    # Check if the result is a monad. Raise a +TypeError+ if not.
    #
    # @param result [Object] Expected a +Monad+.
    def check_type(result)
      return if result.is_a?(self.class)

      msg = "Expected an instance of #{ self.class }, got #{ result.class }"
      fail TypeError, msg
    end
  end
end
