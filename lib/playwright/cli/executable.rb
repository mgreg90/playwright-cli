module Playwright::Cli
  module Executable
    PLAYWRIGHT_CLI_EXEC_DIR = PLAYWRIGHT_CLI_DIR.join('executable')
    Dir[PLAYWRIGHT_CLI_EXEC_DIR.join('*.rb')].each { |f| require f }

    def self.run(argv = ARGV)
      Runner.run(argv)
    end
  end
end