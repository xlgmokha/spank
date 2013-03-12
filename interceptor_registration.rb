require 'proxy'

module Booty
  class InterceptorRegistration
    def initialize(method_symbol)
      @method = method_symbol
    end

    def with(interceptor)
      @interceptor = interceptor
    end

    def intercept(instance)
      proxy= Proxy.new(instance)
      proxy.add(@method, @interceptor)
      proxy
    end
  end
end
