module Playwright::Cli::Lib
  class InputParser
    NotParsedError = Class.new Playwright::Cli::Error

    attr_reader :argv, :command

    def initialize(argv, command)
      @argv = argv
      @command = command
      @has_parsed = false
      @options = OptionCollection.new(command.options)
    end

    def parse!
      @has_parsed = true
      parser.parse!
      # Do stuff
    end

    def parsed?
      @has_parsed
    end

    def args_and_subcommands
      raise NotParsedError if !parsed?
      @args_and_subcommands
    end

    def options
      raise NotParsedError if !parsed?
      @options
    end

    private

    def parser
      OptionParser.new(argv) do |option_parser|
        add_banner(option_parser)
        add_options(option_parser)
      end
    end

    def add_banner parser
    end

    def add_options parser
      option_definitions = command.options
      option_definitions.each do |opt_def|
        args = []
        args << "-#{opt_def.short}" if opt_def.short
        long = "--#{opt_def.name}" if opt_def.name # TODO dashify args
        long += " #{opt_def.name.upcase}" if opt_def.type == :string
        args << long
        args << opt_def.desc if opt_def.desc
        parser.on(*args) do |value|
          @options.push Option.new(opt_def.name, value)
        end
      end
    end

  end
end