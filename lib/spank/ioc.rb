module Spank
  class IOC
    class << self
      def bind_to(container)
        @@container = container
      end

      def resolve(symbol)
        ensure_initialized!
        @@container.resolve(symbol)
      end

      def resolve_all(symbol)
        ensure_initialized!
        @@container.resolve_all(symbol)
      end

      def unbind
        if class_variable_defined?(:@@container)
          remove_class_variable(:@@container)
        end
      end

      private

      def ensure_initialized!
        raise create_error unless class_variable_defined?(:@@container)
      end

      def create_error
        ContainerError.new("Spank::IOC.bind_to(container) has not been called.")
      end
    end
  end
end
