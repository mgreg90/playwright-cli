module Playwright::Cli
  module Lib
    class OptionCollection
      attr_reader :list, :definitions
      def initialize definitions
        @definitions = definitions
        @list = []
      end

      def push option
        raise TypeError unless option.is_a? Option
        @list << option
      end

      def method_missing(m, *args, &block)
        definition = definitions.find { |item| item.name == m }
        if definition
        #   push Option.new(definition.name, )
          require 'pry';binding.pry
        end
        super(m, *args, &block)
      end
    end

    class Option
      attr_reader :name, :value

      def initialize(name, value)
        @name = name
        @value = value
      end
    end
  end
end