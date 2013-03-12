require 'invocation'

module Booty  
  class Proxy
    def initialize(instance)
      @instance = instance
    end

    def add(method, interceptor)
      self.class.define_method(method.to_sym) do |*args|
        interceptor.intercept(create_invocation_for(method, args))
      end
    end

    def create_invocation_for(method, args)
      Invocation.new(@instance, method, args)
    end
  end
end
