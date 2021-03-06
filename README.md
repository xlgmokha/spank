# Spank

A simple light weight inversion of control container written in ruby.

[![Build Status](https://github.com/xlgmokha/spank/workflows/ci/badge.svg)](https://github.com/xlgmokha/spank/actions)
[![Gem Version](https://badge.fury.io/rb/spank.svg)](http://badge.fury.io/rb/spank)

## Installation

Add this line to your application's Gemfile:

    gem 'spank'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spank

## Usage

Register a single component and resolve it.

```ruby
container = Spank::Container.new
container.register(:item) do |container|
  "ITEM"
end
item = container.resolve(:item)
```

Register multiple items, and resolve them.

```ruby
container = Spank::Container.new
container.register(:pants) { jeans }
container.register(:pants) { dress_pants }
pants = container.resolve_all(:pants)
```

Register a singleton.

```ruby
container = Spank::Container.new
container.register(:singleton) { fake }.as_singleton
single_instance = container.resolve(:singleton)
same_instance = container.resolve(:singleton)
```

Automatic dependency resolution.

```ruby
class Child
  def initialize(mom,dad)
  end
end

container = Spank::Container.new
container.register(:mom) { mom }
container.register(:dad) { dad }
child = sut.build(Child)
```

Register selective interceptors.

```ruby
class Interceptor
  def intercept(invocation)
    invocation.proceed
  end
end

class Command
  def run(input)
  end
end

container = Spank::Container.new
container
  .register(:command) { Command.new }
  .intercept(:run)
  .with(Interceptor.new)
proxy = container.resolve(:command)
proxy.run("hi")
```

```ruby
container = Spank::Container.new
Spank::IOC.bind_to(container)
item = Spank::IOC.resolve(:item)
```

Enjoy!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
