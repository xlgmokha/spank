module Booty
  class Invocation
    attr_reader :instance, :method, :arguments

    def initialize(instance, method, args)
      @instance = instance
      @method = method
      @arguments = args
    end

    def proceed
      instance.send(@method, @arguments) 
    end
  end
end
