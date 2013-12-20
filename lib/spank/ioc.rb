module Spank
  class IOC
    class << self
      def bind_to(container)
        @@container = container
      end

      def resolve(symbol)
        raise ContainerError.new unless class_variable_defined?(:@@container)
        @@container.resolve(symbol)
      end

      def unbind
        remove_class_variable(:@@container) if class_variable_defined?(:@@container)
      end
    end
  end
end
