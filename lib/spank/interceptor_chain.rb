module Spank
  class InterceptorChain
    def initialize(interceptors = [])
      @interceptors = interceptors
    end

    def push(interceptor)
      @interceptors.push(interceptor)
    end

    def each(&block)
      @interceptors.each(&block)
    end

    def intercept(invocation)
      each do |interceptor|
        interceptor.intercept(invocation)
      end
    end
  end
end
