module Booty
  class IOC
    def self.bind_to(container)
      @@container = container
    end
    def self.resolve(symbol)
      @@container.resolve(symbol)
    end
  end
end
