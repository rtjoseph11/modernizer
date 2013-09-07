# Modernizer

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'modernizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install modernizer

## Usage
```ruby
Modernizer.new do
  request_version { @env[...] }

  first do
    add('hello') { 'hardcoded' }
  end
 
  modernize '1.2.1' do
    add('foo') { "#{@hash['hello']}-bar" }
  end
 
  modernize '1.2.3' do
    remove 'hello'
    compute('foo') {|x| "baz-#{x}" }
  end
 
  last do
    remove 'foo'
  end
end
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
