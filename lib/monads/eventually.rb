class Eventually < Monad
  def self.from_value(value)
    new do |success|
      success.call(value)
    end
  end

  def initialize(&action)
    @action = action
  end

  def unwrap
    @action
  end

  def run(&success)
    @action.call(success)
  end

  def and_then(&action)
    self.class.new do |success|
      run do |value|
        new_eventually = action.call(value)
        check_type(new_eventually)
        new_eventually.run(&success)
      end
    end
  end
end
