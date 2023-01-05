# frozen_string_literal: true

module LiveLog
  class Boolean; end

  # This method will handle all the configuration types and raise an error if needed
  class Macro
    def self.attr_checker(*attributes)
      attributes.each do |attribute|
        name, type = attribute
        define_method(name) do
          instance_variable_get("@#{name}")
        end

        define_method("#{name}=") do |argument|
          check_boolean(argument, type, name)
          instance_variable_set("@#{name}", argument)
        end
      end
    end

    def check_boolean(argument, type, name)
      if type == Boolean
        raise "LiveLog config: #{name.to_s.capitalize} should be of type Boolean" unless [true, false].include?(argument)
      else
        raise "LiveLog config: #{name.to_s.capitalize} should be of type #{type}" unless argument.instance_of? type
      end
    end
  end
end
