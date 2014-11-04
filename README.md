# Monads

[![Build Status](https://travis-ci.org/ollie/monads-ruby.svg?branch=master)](https://travis-ci.org/ollie/monads-ruby)

TODO: Write a gem description

## Usage

```ruby
include Monads

maybe = Maybe.from_value('Hello world').upcase.reverse
maybe.class  # => Maybe
maybe.unwrap # => 'Hello world'

maybe = Maybe.from_value(nil).upcase.reverse
maybe.class  # => Maybe
maybe.unwrap # => nil

maybe = Maybe.from_value('Hello world').make_nil.upcase.reverse
maybe.class  # => Maybe
maybe.unwrap # => nil

eventually = Eventually.from_value('Hello world').within do |string|
  string.upcase
end.within do |string|
  string.reverse
end

value = eventually.run do |string|
  "Got result: #{ string }"
end # => 'Got result: DLROW OLLEH'
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monads', git: 'https://github.com/ollie/monads-ruby.git'
```

And then execute:

    $ bundle

## Contributing

1. Fork it (https://github.com/ollie/monads-ruby/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
