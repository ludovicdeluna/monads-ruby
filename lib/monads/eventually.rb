module Monads
  # Chain deferred callbacks.
  class Eventually
    # Create a new +Eventually+, pass in the block meant to be run later.
    #
    # @example
    #   e = Eventually.new do |success|
    #     intermediate_result = 5
    #     success.call(intermediate_result)
    #   end.and_then do |intermediate_result|
    #     final_result = intermediate_result * 2
    #
    #     Eventually.new do |success|
    #       success.call(final_result)
    #     end
    #   end
    #
    #   e.run do |result|
    #     puts "The result is #{result}"
    #     # => "The result is 10"
    #   end
    #
    # @param deferred [Proc] Callback to be run later.
    def initialize(&deferred)
      @deferred = deferred
    end

    # Chain another action. This creates a new instance holding a reference
    # to the previous one, but nothing is run at this point.
    #
    # Only when this new instance is run, all other instances are run in order
    # and fed into the next one.
    #
    # It is necessary to return another +Eventually+ from the block otherwise
    # chaining would not be possible
    #
    # @example
    #   e = Eventually.new do |success|
    #     intermediate_result = 5
    #     success.call(intermediate_result)
    #   end.and_then do |intermediate_result|
    #     final_result = intermediate_result * 2
    #
    #     Eventually.new do |success|
    #       success.call(final_result)
    #     end
    #   end
    #
    #   e.run do |result|
    #     puts "The result is #{result}"
    #     # => "The result is 10"
    #   end
    #
    # @param deferred [Proc] New callback to be run later,
    #                        Must return another +Eventually+.
    #
    # @return [Eventually] New monad to be run later.
    def and_then(&deferred)
      self.class.new do |success|
        run do |value|
          new_eventually = deferred.call(value)
          check_type(new_eventually)
          new_eventually.run(&success)
        end
      end
    end

    # Execute the dereffed action and give it the success block.
    # The action may then call the success block.
    #
    # @example
    #   e = Eventually.new do |success|
    #     result = 5
    #     success.call(result)
    #   end
    #
    #   e.run do |result|
    #     puts "The result is #{result}"
    #     # => "The result is 5"
    #   end
    #
    # @param success [Proc] A block to be passed to +@deferred+.
    def run(&success)
      @deferred.call(success)
    end

    protected

    # Check if the result is an +Eventually+ and raise a +TypeError+ if not.
    #
    # @param result [Object] Expected a +Eventually+.
    def check_type(result)
      return if result.is_a?(self.class)

      msg = "Expected an instance of #{self.class}, got #{result.class}"
      fail TypeError, msg
    end
  end
end
