# Monads [![Build Status](https://img.shields.io/travis/ollie/monads-ruby/master.svg)](https://travis-ci.org/ollie/monads-ruby) [![Code Climate](https://img.shields.io/codeclimate/github/ollie/monads-ruby.svg)](https://codeclimate.com/github/ollie/monads-ruby)

This gem is heavily based on Tom Stuart's https://github.com/tomstuart/monads
but hasn't been pushed to rubygems.org. If it turns out to be useful, it may
be pushed with a different name so it doesn't clash with Tom's gem.

## Usage

```ruby
require 'monads/maybe'
include Monads

maybe = Maybe.new('Hello world').upcase.reverse
maybe.class  # => Maybe
maybe.unwrap # => 'Hello world'

maybe = Maybe.new(nil).upcase.reverse
maybe.class  # => Maybe
maybe.unwrap # => nil

maybe = Maybe.new('Hello world').make_nil.upcase.reverse
maybe.class  # => Maybe
maybe.unwrap # => nil
```

```ruby
require 'monads/eventually'
include Monads

eventually = Eventually.new do |success|
  intermediate_result = 5
  success.call(intermediate_result)
end.and_then do |intermediate_result|
  final_result = intermediate_result * 2

  Eventually.new do |success|
    success.call(final_result)
  end
end

eventually.run do |result|
  puts "The result is #{ result }"
  # => "The result is 10"
end
```

```ruby
require 'monads'
include Monads
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monads', git: 'https://github.com/ollie/monads-ruby.git'
```

And then execute:

    $ bundle

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it (https://github.com/ollie/monads-ruby/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
