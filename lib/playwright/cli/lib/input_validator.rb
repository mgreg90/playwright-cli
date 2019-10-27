module Playwright::Cli::Lib
  class InputValidator

    def initialize(command, args_and_subcommands, options)
      @command = command
      @args_and_subcommands = args_and_subcommands
      @options = options
    end

    def validate!
      # TODO implement
      raise NotImplementedError
    end

  end
end