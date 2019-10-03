# This runner is for running individual playwright scripts.
module Playwright::Cli::Lib
  class Runner
    def self.call(command, argv = ARGV)
      new(
        command,
        parser: InputParser,
        validator: InputValidator
        argv: argv
      ).call
    end

    def initialize(command, parser: InputParser, validator: InputValidator, argv: ARGV)
      @command_class = command
      @parser_class = parser
      @validator_class = validator
      @argv = argv
      validate!
    end

    def call
      parse!
      validate!
      command = command_class.new(inputs)
      command.run
    end

    private
    
    attr_reader :command_class, :parser_class, :validator_class, :args_and_subcommands, :options

    def validate!
      raise ValidationError.new('parser does not respond to #parse !') if !parser.respond_to?(:parse)
      raise ValidationError.new('validator does not respond to #validate !') if !validator.respond_to?(:validate)
    end

    def parse!
      return true if @parser && @parser.parsed?
      @parser = parser_class.new(argv, command_class) # Command class is needed to define options and infer help
      @parser.parse!
      @args_and_subcommands = parser.args_and_subcommands
      @options = parser.options
    end

    def validate!
      return true if @validator && @validator.validated?
      @validator = validator_class.new(command, args_and_subcommands, options)
      @validator.validate!
    end
  end
end