module Spank
  class InterceptorRegistration
    def initialize(method_symbol)
      @method = method_symbol
      @interceptors = []
    end

    def with(interceptor)
      @interceptors.push(interceptor)
      self
    end

    def and(interceptor)
      with(interceptor)
    end

    def intercept(instance)
      proxy = Proxy.new(instance)
      @interceptors.each do |interceptor|
        proxy.add_interceptor(@method, interceptor)
      end
      proxy
    end
  end
end
