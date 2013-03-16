require 'invocation'

module Booty
  class Proxy
    def initialize(target)
      @target = target
    end

    def add_interceptor(method, interceptor)
      self.class.define_method(method.to_sym) do |*args|
        interceptor.intercept(create_invocation_for(method, args))
      end
    end

    def create_invocation_for(method, args)
      Invocation.new(@target, method, args)
    end

    def method_missing(method, *args, &block)
      @target.public_send(method, *args, block)
    end
  end
end
