Playwright::Cli
=====

This is in development. The API described below are the expected contract and not yet implemented or confirmed.

## Why Use Playwright

Playwright aims to be a ruby library for building and (eventually) sharing command line applications easily.

This is project is experimental and not yet v1.0.0

## Goals
* Easy API for handling inputs for command line apps
* Simple API for common flags (--debug, --verbose, etc)
* Server to post and share scripts

# How to use

## Setup
```ruby
# For single file ruby scripts, use inline bundler to get playwright
require 'bundler/inline'

gemfile do
  gem 'playwright-cli'
end

class ExampleCli < Playwright::Cli::Base
  version = '0.0.1'
  # Define a run method and put logic there
  def run
  end
end

ExampleCli.call(ARGV)
```

## Utilities

By inheriting from `Playwright::Cli::Base`, you have access to some useful APIs:
* io
* finish

### io

#### io.say
Print message in neutral format.
```ruby
def run
  io.say "Oh hey wow!"
end
```

#### io.ask
Get interactive input from the user.

Options:
 * inline
 * type

```ruby
class HelloCli < Playwright::Cli::Base
  root :hello

  def run
    name = io.ask "What's your name?"
    io.say "Hey #{name}!"
  end
end
```

```sh
$ hello
> What's your name?
> bob # <-- user input
> Hey bob!
```

##### inline

```ruby
class HelloCli < Playwright::Cli::Base
  root :hello

  def run
    name = io.ask "What's your name?", inline: true
    io.say "Hey #{name}!"
  end
end
```

```sh
$ hello
> What's your name? bob # <-- user input is inline
> Hey bob!
```

##### type
Use the `type` option to change the type of the input. Currently supporting `:bool` and `:string`. The default is `:string`.

When using type `:bool`, you can set default as `true` or `false`.
The default will be false unless otherwise set.

```ruby
class HelloCli < Playwright::Cli::Base
  root :hello

  def run
    will_print_timestamp = io.ask "Print a timestamp?", type: :bool, default: true
    io.say "#{Time.now.utc.to_s}" if will_print_timestamp
  end
end
```

```sh
$ hello
> Print a timestamp? [Yn]
> y
> [2019-09-29 03:05:03 UTC]
```
```sh
$ hello
> Print a timestamp? [Yn]
>
> [2019-09-29 03:05:03 UTC]
```

#### io.warn

`io.warn` works the same as `io.say`, but it displays in warning colors.

#### io.error

`io.error` works the same as `io.say`, but it displays in error colors.

To fail the workflow with an error, use `finish :fail`

### finish
`finish` ends a workflow in either `:success` or `:failure`. Default is `:success`.

```ruby
def run
  io.say "Oh hey wow!"
  finish :success # optional
end
```
```sh
$ hello && echo wow
> Oh Hey wow!
> wow
```
```ruby
def run
  io.say "Oh hey wow!"
  finish :failure
end
```
```sh
$ hello && echo wow
> Oh Hey wow!
```

## Attributes
Define the attributes of your CLI:
* Root command (required)
* Arguments
* Options
* Subcommands

### Root Command
Defining your root command is required.

To define your root command:
```ruby
class HelloCli < Playwright::Cli::Base
  root :hello

  def run
    io.say("Hello!")
  end
end
```
for
```sh
$ hello
```

### Arguments
Use the `argument` attribute to define arguments

Arguments are user inputs that are always required. If you want to define an optional input, use an option.
```ruby
class HelloCli < Playwright::Cli::Base
  root :hello
  arguments :name, :message

  def run
    message = "Hey #{args.name}! #{args.message}"
    io.say(message)
  end
end
```
for
```sh
$ hello bob "How are you?"
> Hey bob! How are you?
```

If required argument isn't passed:
```sh
$ hello
> Error: Required argument missing. See usage with `$ hello --help`
```

### Options

Use the `option` attribute to define options and flags.

The `short` modifier (optional) defines the short way of adding the option (`-m` instead of `--message`).

The `type` modifier (optional) lets you change the type of option. The only two types currently supported are `:string` and `:boolean`. The default is `:boolean`.
```ruby
class HelloCli < Playwright::Cli::Base
  root :hello
  arguments :name
  option :message, short: :m, type: :string
  option :timestamp, short: :t

  def run
    message = "Hey #{args.name}!"
    message += " #{options.message}" if options.message
    message += " [#{Time.now.utc}]" if options.timestamp? # referencing boolean options can append `?` or not.
    io.say(message)
  end
end
```
```sh
$ hello bob -t
> Hey bob! [2019-09-29 03:05:03 UTC]
```
```sh
$ hello bob "How are you?" -t
> Hey bob! How are you [2019-09-29 03:05:03 UTC]
```

### Subcommands

Use the `subcommand` attribute to register a subcommand.

Subcommands are defined in the same way as commands. They use `root` to define their command in the same way.

Subcommands should inherit from `Playwright::Cli::Base`

To register a subcommand:
```ruby
class HelloCli < Playwright::Cli::Base
  root :hello
  subcommand HelloCli::Print
  option :timestamp, short: :t
end

class HelloCli::Print < Playwright::Cli::Base
  root :print
  arguments :name
  option :timestamp, short: :t

  def run
    message = "Hey #{args.name}!"
    message += " [#{Time.now.utc}]" if options.timestamp? # referencing boolean options can append `?` or not.
    io.say(message)
  end
end
```
```sh
$ hello print bob --timestamp
> "Hey bob! [2019-09-29 03:05:03 UTC]"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/playwright-cli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

