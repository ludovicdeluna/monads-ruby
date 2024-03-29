RSpec.describe Eventually do
  it 'new' do
    callback = lambda do |success|
      success.call('Hello world')
    end

    eventually = Eventually.new(&callback)
    expect(eventually.run { |result| result }).to eq('Hello world')
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
      "Got result: #{string}"
    end

    expect(value).to eq('Got result: DLROW OLLEH')
  end

  it 'new + and_then raises an error when result is not an Eventually' do
    eventually = Eventually.new do |success|
      success.call('Hello world')
    end.and_then(&:upcase).and_then do |string|
      Eventually.new do |success|
        success.call(string.reverse)
      end
    end

    expect do
      eventually.run do |string|
        "Got result: #{string}"
      end
    end.to raise_error(TypeError)
  end
end
