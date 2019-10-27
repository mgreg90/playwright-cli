module Playwright::Cli::Lib
  class OptionDefinition
    attr_reader :name, :short, :type, :desc

    TYPES = [:boolean, :string]

    def initialize name:, short: nil, type: :boolean, desc: nil
      @name = name
      @short = short
      @type = type
      @desc = desc
      validate!
    end

    def == other
      name == other.name &&
        type == other.type
    end

    private

    def validate!
      raise ValidationError.new("Invalid type.") unless TYPES.include? @type
    end
  end
end