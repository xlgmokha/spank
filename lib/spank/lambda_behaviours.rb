module Spank
  module LambdaBehaviours
    def memoize(lambda_method)
      lambda { |*args| @cache ||= lambda_method.call(*args) }
    end
  end
end
