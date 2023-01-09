# frozen_string_literal: true

module LiveLog
  # This class is supposed to be comparable
  class Boolean; end # rubocop:disable Lint/EmptyClass

  # This class will handle all the configuration types and raise an error if needed
  class Macro
    # Set and get the attributes by checking the types
    #
    # @param [Array[string, class]] attributes each attribute comes with a specific format [name, type]
    def self.attr_checker(*attributes)
      attributes.each do |attribute|
        name, type = attribute
        define_method(name) do
          instance_variable_get("@#{name}")
        end

        define_method("#{name}=") do |argument|
          check_type(argument, type, name)
          instance_variable_set("@#{name}", argument)
        end
      end
    end

    # Checks if attribute has correct type
    #
    # @param [any] argument argument of type class
    # @param [Class] type class of attribute
    # @param [String] name name of attribute
    def check_type(argument, type, name)
      if type == Boolean
        raise "LiveLog config: #{name.to_s.capitalize} should be of type Boolean" unless [true, false].include?(argument)
      else
        raise "LiveLog config: #{name.to_s.capitalize} should be of type #{type}" unless argument.instance_of? type
      end
    end
  end
end
