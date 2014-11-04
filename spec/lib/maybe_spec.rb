RSpec.describe Maybe do
  context 'With sugar' do
    it 'from_value + within' do
      maybe = Maybe.from_value('Hello world').upcase.reverse
      expect(maybe.unwrap).to eq('DLROW OLLEH')
    end

    it 'from_value + nil + within' do
      maybe = Maybe.from_value(nil).upcase.reverse
      expect(maybe.unwrap).to eq(nil)
    end

    it 'new + within' do
      maybe = Maybe.new('Hello world').upcase.reverse
      expect(maybe.unwrap).to eq('DLROW OLLEH')
    end

    it 'respond_to?' do
      maybe = Maybe.from_value('Hello world').upcase.reverse
      expect(maybe.respond_to?(:size)).to eq(true)
    end
  end

  it 'new' do
    maybe = Maybe.new('Hello world')
    expect(maybe.unwrap).to eq('Hello world')
  end

  it 'from_value' do
    maybe = Maybe.from_value('Hello world')
    expect(maybe.unwrap).to eq('Hello world')
  end

  it 'from_value + within' do
    maybe = Maybe.from_value('Hello world').within do |string|
      string.upcase
    end.within do |string|
      string.reverse
    end

    expect(maybe.unwrap).to eq('DLROW OLLEH')
  end

  it 'from_value + nil + within' do
    maybe = Maybe.from_value('Hello world').within do |string|
      nil
    end.within do |string|
      string.reverse
    end

    expect(maybe.unwrap).to eq(nil)
  end

  it 'new + within' do
    maybe = Maybe.new('Hello world').within do |string|
      string.upcase
    end.within do |string|
      string.reverse
    end

    expect(maybe.unwrap).to eq('DLROW OLLEH')
  end

  it 'from_value + and_then' do
    maybe = Maybe.from_value('Hello world').and_then do |string|
      Maybe.from_value(string.upcase)
    end.and_then do |string|
      Maybe.from_value(string.reverse)
    end

    expect(maybe.unwrap).to eq('DLROW OLLEH')
  end

  it 'from_value + nil + and_then' do
    maybe = Maybe.from_value('Hello world').and_then do |string|
      Maybe.from_value(nil)
    end.and_then do |string|
      Maybe.from_value(string.reverse)
    end

    expect(maybe.unwrap).to eq(nil)
  end

  it 'new + and_then' do
    maybe = Maybe.new('Hello world').and_then do |string|
      Maybe.new(string.upcase)
    end.and_then do |string|
      Maybe.new(string.reverse)
    end

    expect(maybe.unwrap).to eq('DLROW OLLEH')
  end

  it 'new + and_then raises an error when result is not a Maybe' do
    expect do
      Maybe.new('Hello world').and_then do |string|
        string.upcase
      end.and_then do |string|
        Maybe.new(string.reverse)
      end
    end.to raise_error(TypeError)
  end
end
