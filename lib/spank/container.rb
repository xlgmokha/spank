module Spank
  class Container
    def initialize
      @items = {}
      register(:container) { self }
    end

    def register(key, &block)
      component = Component.new(key, &block)
      components_for(key).push(component)
      component
    end

    def resolve(key)
      instantiate(components_for(key).first, key)
    end

    def resolve_all(key)
      components_for(key).map {|item| instantiate(item, key) }
    end

    def build(type)
      try("I could not create: #{type}"){ build!(type) }
    end

    def build!(type)
      constructor = type.instance_method('initialize')
      parameters = constructor.parameters.map do |req, parameter|
        resolve(parameter.to_sym)
      end
      type.send(:new, *parameters)
    end

    private

    def components_for(key)
      @items[key] = [] unless @items[key]
      @items[key]
    end

    def instantiate(component, key)
      raise ContainerError.new("#{key} is not a registered component.") unless component
      component.create(self)
    end

    def try(error = nil, &lambda)
      begin
        lambda.call
      rescue => e
        raise Spank::ContainerError.new(error ||= "Oops: #{e}")
      end
    end
  end
end
