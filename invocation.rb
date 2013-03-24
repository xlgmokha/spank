module Booty
  class Invocation
    attr_reader :instance, :method, :arguments, :result

    def initialize(instance, method, args, block)
      @instance = instance
      @method = method
      @arguments = args
      @block = block
    end

    def proceed
      if @block
        @result = @instance.public_send(@method, @arguments, @block)
      else
        @result = @instance.public_send(@method, @arguments)
      end
    end
  end
end
