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
  end
