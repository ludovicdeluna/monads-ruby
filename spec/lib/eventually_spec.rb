RSpec.describe Eventually do
  it 'new' do
    callback = lambda do |success|
      success.call('Hello world')
    end

    eventually = Eventually.new(&callback)
    expect(eventually.run { |result| result }).to eq('Hello world')
  end

  it 'from_value' do
    eventually = Eventually.from_value('Hello world')
    expect(eventually).to be_a(Eventually)
    expect(eventually.run { |result| result }).to eq('Hello world')
  end

  it 'from_value + within' do
    eventually = Eventually.from_value('Hello world').within do |string|
      string.upcase
    end.within do |string|
      string.reverse
    end

    value = eventually.run do |string|
      "Got result: #{ string }"
    end

    expect(value).to eq('Got result: DLROW OLLEH')
  end

  it 'new + within' do
    eventually = Eventually.new do |success|
      success.call('Hello world')
    end.within do |string|
      string.upcase
    end.within do |string|
      string.reverse
    end

    value = eventually.run do |string|
      "Got result: #{ string }"
    end

    expect(value).to eq('Got result: DLROW OLLEH')
  end

  it 'from_value + and_then' do
    eventually = Eventually.from_value('Hello world').and_then do |string|
      Eventually.from_value(string.upcase)
    end.and_then do |string|
      Eventually.from_value(string.reverse)
    end

    value = eventually.run do |string|
      "Got result: #{ string }"
    end

    expect(value).to eq('Got result: DLROW OLLEH')
  end

  it 'new + and_then' do
    eventually = Eventually.new do |success|
      success.call('Hello world')
    end.and_then do |string|
      Eventually.new do |success|
        success.call(string.upcase)
      end
    end.and_then do |string|
      Eventually.new do |success|
        success.call(string.reverse)
      end
    end

    value = eventually.run do |string|
      "Got result: #{ string }"
    end

    expect(value).to eq('Got result: DLROW OLLEH')
  end

  it 'new + and_then raises an error when result is not an Eventually' do
    eventually = Eventually.new do |success|
      success.call('Hello world')
    end.and_then do |string|
      string.upcase
    end.and_then do |string|
      Eventually.new do |success|
        success.call(string.reverse)
      end
    end

    expect do
      eventually.run do |string|
        "Got result: #{ string }"
      end
    end.to raise_error(TypeError)
  end
end
