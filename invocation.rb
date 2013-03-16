module Booty
  class Invocation
    attr_reader :instance, :method, :arguments

    def initialize(instance, method, args, block)
      @instance = instance
      @method = method
      @arguments = args
      @block = block
    end

    def proceed
      if @block
        instance.public_send(@method, @arguments, @block)
      else
        instance.public_send(@method, @arguments)
      end
    end
  end
end
