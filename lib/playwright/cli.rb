%w( colorize pathname ).each { |lib| require lib }

module Playwright
  module Cli
    module Lib; end
    class Error < StandardError; end
    class ValidationError < Error; end

    ROOT_DIR = Pathname.new(File.expand_path('..', __FILE__))
    PLAYWRIGHT_CLI_DIR = ROOT_DIR.join('cli')
    Dir[PLAYWRIGHT_CLI_DIR.join('*.rb')].each { |f| require f }
    Dir[PLAYWRIGHT_CLI_DIR.join('**', '*.rb')].each { |f| require f }
    Dir[PLAYWRIGHT_CLI_DIR.join('**', '**', '*.rb')].each { |f| require f }

  end
end
