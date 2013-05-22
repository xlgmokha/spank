module Spank
  class Proxy
    def initialize(target, interceptor_chain = InterceptorChain.new)
      @target = target
      @interceptor_chain = interceptor_chain
    end

    def add_interceptor(method, interceptor)
      @interceptor_chain.push(interceptor)
      self.extend(create_module_for(method))
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

    def create_module_for(method)
      Module.new do
        define_method(method.to_sym) do |*args, &block|
          invocation = create_invocation_for(method, args, block)
          @interceptor_chain.each do |interceptor|
            interceptor.intercept(invocation)
          end
          invocation.result
        end
      end
    end
  end
end
