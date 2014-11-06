RSpec.describe Maybe do
  context 'With sugar' do
    it 'new + and_then' do
      maybe = Maybe.new('Hello world').upcase.reverse
      expect(maybe.unwrap).to eq('DLROW OLLEH')
    end

    it 'new + nil + and_then' do
      maybe = Maybe.new(nil).upcase.reverse
      expect(maybe.unwrap).to eq(nil)
    end

    it 'respond_to?' do
      maybe = Maybe.new('Hello world').upcase.reverse
      expect(maybe.respond_to?(:size)).to eq(true)
    end
  end

  it 'new' do
    maybe = Maybe.new('Hello world')
    expect(maybe.unwrap).to eq('Hello world')
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
