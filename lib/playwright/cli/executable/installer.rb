# This class is for installing individual playwright plays.
module Playwright::Cli::Executable
  class Installer
  end

  # NOTE - We will need templates for the generated files.

  # Setup
  # 1. mkdir -p "$HOME/.playwright/plays"
  # 2. mkdir -p "$HOME/.playwright/bin"
  # 3. Add $HOME/.playwright/bin to PATH
  # 4. chmod u+x everything in ~/.playwright/bin

  # On Generate
    # 1. Call Setup
    # 2. touch $HOME/.playwright/bin/new-script
    # 3. mkdir $HOME/.playwright/plays/new-script
    # 4. touch $HOME/.playwright/plays/new-script/main.rb
    # 5. touch $HOME/.playwright/plays/new-script/Gemfile
    # 6. bundle
end