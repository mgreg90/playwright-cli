require 'bundler/setup'
require 'playwright/cli'
require 'tempfile'
require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Comment out this block to use pry within a test
  # config.before do
  #   $stdout = Tempfile.new
  # end
end
