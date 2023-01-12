require 'binding_of_caller'

module LiveLog
  # Binding class
  class Binding
    attr_reader :previous

    def initialize(prev)
      @previous = prev
    end

    def class
      previous.eval('self').class.to_s
    end

    def method
      previous.frame_description
    end
  end
end
