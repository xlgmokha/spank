require 'invocation'

module Booty
  class Proxy
    def initialize(target)
      @target = target
    end

    def add_interceptor(method, interceptor)
      #self.class.define_method(method.to_sym) do |*args, &block|
        #interceptor.intercept(create_invocation_for(method, args, block))
      #end

      mod = Module.new do
        define_method(method.to_sym) do |*args, &block|
          p "CALLING #{method}"
          invocation = create_invocation_for(method, args, block)
          interceptor.intercept(invocation)
          invocation.result
        end
      end
      self.extend(mod)
      self
    end

    def create_invocation_for(method, args, block)
      Invocation.new(@target, method, args, block)
    end

    def method_missing(method, *args, &block)
      if block
        @target.public_send(method, *args, block)
      else
        @target.public_send(method, *args)
      end
    end
  end
end
