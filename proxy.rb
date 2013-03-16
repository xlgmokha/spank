require 'invocation'

module Booty
  class Proxy
    def initialize(target)
      @target = target
    end

    def add_interceptor(method, interceptor)
      self.class.define_method(method.to_sym) do |*args, &block|
        interceptor.intercept(create_invocation_for(method, args, block))
      end
    end

    def create_invocation_for(method, args, block)
      Invocation.new(@target, method, args, block)
    end

    def method_missing(method, *args, &block)
      @target.public_send(method, *args, block)
    end
  end
end
