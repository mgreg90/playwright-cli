module Playwright
  module Cli
    class Option
      attr_reader :name, :short, :type

      TYPES = [:boolean, :string]

      def initialize name:, short: nil, type: :boolean
        @name = name
        @short = short
        @type = type
        validate!
      end

      def == other
        name == other.name &&
          short == other.short &&
          type == other.type
      end

      private

      def validate!
        raise ValidationError.new("Invalid type.") unless TYPES.include? @type
      end
    end
  end
end