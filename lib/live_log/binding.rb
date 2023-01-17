# frozen_string_literal: true

require 'ruby_parser'

module LiveLog
  # Binding class
  class Binding
    attr_accessor :classname, :caller

    def initialize(caller_str = '', listener_classes = %w[PageController OlaController])
      @listener_classes = listener_classes
      @caller = caller_str.match(Regexp.new(regex_pattern)) do |m|
        Struct.new(:filepath, :line, :method, :class, :module).new(*m.captures) # rubocop:disable Lint/StructNewOverride
      end
      parser if @caller
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    def parser
      contents = RubyParser.new.parse(File.read(@caller.filepath), @caller.filepath)
      # Matchers to check if files contain the listener classes and method
      matcher_classes = Sexp::Matcher.parse("(class [m /#{@listener_classes.join('|')}/] ___)")
      matcher_method = Sexp::Matcher.parse("(defn [m /^#{@caller.method}/] ___)")
      # Check if file has listener classes
      query_classes = (contents / matcher_classes)
      # Loop classes if not empty
      return if query_classes.empty? && @caller.method

      query_classes.each do |cls|
        # S-expression of standard rails logs
        pattern = s(:call, s(:const, :Rails), :logger)
        # Loop methods if not empty
        (cls / matcher_method).each do |med|
          # If S-expression matches standard rails logs, line and type call
          # Return corresponding class
          med.deep_each do |s_exp|
            @classname = JSON.parse(cls.to_json).second if s_exp == pattern &&
                                                           s_exp.sexp_type == :call &&
                                                           s_exp.line == @caller.line.to_i
          end
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

    private

    def regex_pattern
      '(?<filepath>[\\S]+):(?<line>[\\d]*):[\\S\\s]+' \
        '((`(?<method>[^<][\\S]+)\')|`<class:(?<class>[\\S]+)>|`<module:(?<module>[\\S]+)>)'
    end
  end
end
