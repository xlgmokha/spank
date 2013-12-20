module Spank
  class ContainerError < Exception
    def intialize(message)
      @message = message
    end
  end
end
