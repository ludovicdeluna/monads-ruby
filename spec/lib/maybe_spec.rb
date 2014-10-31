RSpec.describe Maybe do
  context 'With method_missing suger' do
    it 'nested hash example' do
      user = {
        address: {
          city: 'Boulder'
        }
      }

      result = Maybe(user)[:address][:city].unwrap
      expect(result).to eq('Boulder')
    end

    it 'nested hash example with missing address' do
      user = {}

      result = Maybe(user)[:address][:city].unwrap
      expect(result).to eq(nil)
    end

    it 'Hello becomes OLLEH' do
      result = Maybe('Hello').upcase.reverse.unwrap

      expect(result).to eq('OLLEH')
    end

    it 'Hello becomes nil somewhere along the way' do
      result = Maybe('Hello').and_then do |_v|
        nil
      end.reverse.unwrap

      expect(result).to eq(nil)
    end

    it 'nil is nil' do
      result = Maybe(nil).unwrap

      expect(result).to eq(nil)
    end

    it 'responds to :upcase' do
      wrapped_value = Maybe('Hello')

      expect(wrapped_value.respond_to?(:upcase)).to eq(true)
    end
  end

  context 'Without sugar' do
    it 'Hello becomes OLLEH' do
      result = Maybe('Hello').and_then do |v|
        v.upcase
      end.and_then do |v|
        v.reverse
      end.unwrap

      expect(result).to eq('OLLEH')
    end

    it 'Hello becomes nil somewhere along the way' do
      result = Maybe('Hello').and_then do |_v|
        nil
      end.and_then do |v|
        v.reverse
      end.unwrap

      expect(result).to eq(nil)
    end

    it 'nil is nil' do
      result = Maybe(nil).unwrap

      expect(result).to eq(nil)
    end

    it 'nil is nil 2' do
      result = Maybe(nil).and_then do |_v|
        nil
      end.and_then do |_v|
        nil
      end.unwrap

      expect(result).to eq(nil)
    end
  end
end
