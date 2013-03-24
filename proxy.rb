require 'invocation'

module Booty
  class Proxy
    def initialize(target)
      @target = target
    end

    def add_interceptor(method, interceptor)
      self.extend(create_module_for(method, interceptor))
      self
    end

    private

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

    def create_module_for(method, interceptor)
      Module.new do
        define_method(method.to_sym) do |*args, &block|
          invocation = create_invocation_for(method, args, block)
          interceptor.intercept(invocation)
          invocation.result
        end
      end
    end
  end
end
