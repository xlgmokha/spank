module Spank
  class IOC
    class << self
      def bind_to(container)
        @@container = container
      end

      def resolve(symbol)
        raise create_error unless class_variable_defined?(:@@container)
        @@container.resolve(symbol)
      end

      def unbind
        remove_class_variable(:@@container) if class_variable_defined?(:@@container)
      end

      private

      def create_error
        ContainerError.new("Spank::IOC.bind_to(container) has not been called.")
      end
    end
  end
end
