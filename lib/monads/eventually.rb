module Monads
  # Chain deferred callbacks.
  #
  # @example
  #   include Monads
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
  class Eventually < Monad
    # Wrap a callback into an Eventually monad. Since monads are chainable
    # it's easy to define multiple callbacks without the pyramid of doom.
    #
    # @example
    #   eventually = Eventually.from_value('Hello world')
    #   eventually.run { |result| result } # => 'Hello world'
    #
    # @param value [Object] Any value.
    #
    # @return [Eventually]
    def self.from_value(value)
      new do |success|
        success.call(value)
      end
    end

    # Wrap a callback into an Eventually monad. Since monads are chainable
    # it's easy to define multiple callbacks without the pyramid of doom.
    #
    # @example
    #   eventually = Eventually.new do |success|
    #     success.call('Hello world')
    #   end
    #
    #   eventually.run { |result| result } # => 'Hello world'
    #
    # @param callback [Proc] Callback to be run later.
    #
    # @return [Eventually]
    def initialize(&callback)
      @callback = callback
    end

    # Take a block and call the callback with it. The callback will then
    # call it with the value.
    #
    # @example
    #   eventually = Eventually.new do |success|
    #     success.call('Hello world')
    #   end
    #
    #   eventually.run { |result| result } # => 'Hello world'
    #
    # @param success [Proc] A block to be passed to +callback+.
    #
    # @return [Object]
    def run(&success)
      @callback.call(success)
    end

    # Chain with another Eventually monad. The passed block needs to return
    # a monad.
    #
    # @example
    #   eventually = Eventually.from_value('Hello world').and_then do |string|
    #     Eventually.from_value(string.upcase)
    #   end.and_then do |string|
    #     Eventually.from_value(string.reverse)
    #   end
    #
    #   value = eventually.run do |string|
    #     "Got result: #{ string }"
    #   end # => 'Got result: DLROW OLLEH'
    #
    # @see Monad#within
    #
    # @param callback [Proc] New callback to be run later,
    #                        Must return another +Eventually+.
    #
    # @return [Eventually] New monad to be run later.
    def and_then(&callback)
      self.class.new do |success|
        run do |value|
          new_eventually = callback.call(value)
          check_type(new_eventually)
          new_eventually.run(&success)
        end
      end
    end
  end
end
