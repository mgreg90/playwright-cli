# require_relative "./input_parser"
# This runner is for running individual playwright scripts.
module Playwright::Cli
  module Lib
    class Runner
      # def self.run(command, argv = ARGV)
      #   new(
      #     command,
      #     parser: InputParser,
      #     validator: InputValidator,
      #     argv: argv
      #   ).call
      # end

      def initialize(command, parser: InputParser, validator: InputValidator, argv: ARGV)
        @command = command
        @parser_class = parser
        @validator_class = validator
        @argv = argv
        validate!
      end

      def call
        parse!
        # validate!
        command.run
      end

      private
      
      attr_reader :command,
        :parser_class,
        :validator_class,
        :args_and_subcommands,
        :options,
        :argv

      def validate!
        raise ValidationError.new('parser does not respond to #parse !') if !parser.respond_to?(:parse!)
        raise ValidationError.new('validator does not respond to #validate !') if !validator.respond_to?(:validate!)
      end

      def parse!
        return true if @parser && @parser.parsed?
        parser.parse!
        @args_and_subcommands = parser.args_and_subcommands
        @options = parser.options
      end

      # def validate!
      #   return true if @validator && @validator.validated?
      #   validator.validate!
      # end

      private

      def parser
        @parser ||= parser_class.new(argv, command)
      end

      def validator
        @validator ||= validator_class.new(command, args_and_subcommands, options)
      end
    end
  end
end