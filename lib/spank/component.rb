require 'lambda_behaviours'
require "interceptor_registration"

module Booty
  class Component
    include LambdaBehaviours

    def initialize(class_key, &block)
      @factory_method = block
      @interceptors = []
    end

    def create(container)
      instance = @factory_method.call(container)
      @interceptors.each do |interceptor|
        instance = interceptor.intercept(instance)
      end
      instance
    end

    def as_singleton
      @factory_method = memoize(@factory_method)
    end

    def intercept(method)
      interceptor = InterceptorRegistration.new(method)
      @interceptors.push(interceptor)
      interceptor
    end
  end
end
