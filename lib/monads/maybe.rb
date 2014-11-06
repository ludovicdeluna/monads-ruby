module Monads
  # Wrap a value into a Maybe monad. Since monads are chainable and every
  # value is wrapped in one, things don't blow up with +NoMethodError+ on
  # +nil+s.
  class Maybe
    # Wrap a value into a Maybe monad. Since monads are chainable and every
    # value is wrapped in one, things don't blow up with +NoMethodError+ on
    # +nil+s.
    #
    # @example
    #   maybe = Maybe.new('Hello world').upcase.reverse
    #   maybe.class  # => Maybe
    #   maybe.unwrap # => 'Hello world'
    #
    #   maybe = Maybe.new(nil).upcase.reverse
    #   maybe.class  # => Maybe
    #   maybe.unwrap # => nil
    #
    #   maybe = Maybe.new('Hello world').make_nil.upcase.reverse
    #   maybe.class  # => Maybe
    #   maybe.unwrap # => nil
    #
    # @param value [Object] Any value including +nil+.
    def initialize(value)
      @value = value
    end

    # Return the wrapped value.
    #
    # @example
    #   Maybe.new('Hello').unwrap        # => 'Hello'
    #   Maybe.new('Hello').upcase.unwrap # => 'HELLO'
    #   Maybe.new(nil).upcase.unwrap     # => nil
    #
    # @return [Object]
    def unwrap
      @value
    end

    # Chain with another Maybe monad. The yielded block needs to return a monad.
    # This is pretty verbose so it's easier to use the method_missing sugar.
    #
    # @example
    #   Maybe.new('Hello world').and_then do |string|
    #     Maybe.new(string.upcase)
    #   end.and_then do |string|
    #     Maybe.new(string.reverse)
    #   end.unwrap # => 'DLROW OLLEH'
    #
    #   Maybe.new('Hello world').and_then do |string|
    #     Maybe.new(nil)
    #   end.and_then do |string|
    #     Maybe.new(string.reverse)
    #   end.unwrap # => nil
    #
    # @yieldparam value [Object] Unwrapped value goes in the block.
    # @yieldreturn      [Maybe]  Must return another +Maybe+.
    #
    # @return [Maybe] The monadic value of the yielded block.
    def and_then
      return self if @value.nil?

      new_maybe = yield @value
      check_type(new_maybe)
      new_maybe
    end

    # Syntactic sugar for easy monad chaining with simple method calls.
    #
    # @example
    #   Maybe.new('Hello world').upcase.reverse
    #
    # @return [Maybe] The result wrapped in a +Maybe+.
    def method_missing(*args, &block)
      and_then do |value|
        new_value = value.public_send(*args, &block)
        self.class.new(new_value)
      end
    end

    # Also support +respond_to?+.
    #
    # @example
    #   Maybe.new('Hello world').upcase.reverse.respond_to?(:size) # => true
    #
    # @return [Bool]
    def respond_to_missing?(method_name, include_private = false)
      super || and_then do |value|
        return value.respond_to?(method_name, include_private)
      end
    end

    protected

    # Check if the result is an +Eventually+ and raise a +TypeError+ if not.
    #
    # @param result [Object] Expected a +Eventually+.
    def check_type(result)
      return if result.is_a?(self.class)

      msg = "Expected an instance of #{ self.class }, got #{ result.class }"
      fail TypeError, msg
    end
  end
end
