%w( colorize ).each { |lib| require lib }

module Playwright
  module Cli
    class Error < StandardError; end
    class ValidationError < Error; end

    ROOT_DIR = File.expand_path('..', __FILE__)
    Dir[File.join(ROOT_DIR, "cli", "*.rb")].each { |f| require f }

    class Base
      include Finish
      include Io

      class << self
        attr_accessor :options, :subcommands
        attr_writer :version, :root, :args

        def inherited(other)
          other.options = []
          other.subcommands =  []
          other.version = nil
          other.root = nil
          other.args = nil
        end

        def version new_version = nil
          new_version ? @version = new_version : @version
        end

        def root new_root = nil
          new_root ? @root = new_root : @root
        end

        def arguments new_args = nil
          new_args ? @args = new_args : @args
        end
        alias_method :args, :arguments

        def option name, short: nil, type: :boolean
          new_option = Option.new(
            name: name,
            short: short,
            type: type
          )
          @options.push new_option
        end

        def subcommand new_subcommand
          is_error = !defined?(new_subcommand) || !new_subcommand.is_a?(Class) || !new_subcommand.ancestors.include?(Playwright::Cli::Base)
          raise ValidationError.new("Subcommand does not exist!") if is_error
          @subcommands.push new_subcommand
        end
      end

      def version
        self.class.version
      end

      def root
        self.class.root
      end

      def arguments
        self.class.arguments
      end
      alias_method :args, :arguments

      def options
        self.class.options
      end

      def call
        finish :failure if !defined?(:run)
      end

      def validate!
        raise ValidationError.new("Root is missing!") if !root
      end
    end
  end
end
