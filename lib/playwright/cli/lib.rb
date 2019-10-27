module Playwright::Cli
  module Lib
    PLAYWRIGHT_CLI_LIB_DIR = PLAYWRIGHT_CLI_DIR.join('lib')
    Dir[PLAYWRIGHT_CLI_LIB_DIR.join('*.rb')].each { |f| require f }
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

        def call(argv = ARGV)
          new(argv).call
        end

        def version new_version = nil
          new_version ? @version = new_version : @version
        end

        def root new_root = nil
          new_root ? @root = new_root : @root
        end

        def arguments *new_args
          new_args = new_args.flatten
          !new_args.empty? ? @args = new_args : @args
        end
        alias_method :args, :arguments

        def option name, short: nil, type: :boolean, desc: nil
          new_option = OptionDefinition.new(
            name: name,
            short: short,
            type: type,
            desc: desc
          )
          @options.push new_option
        end

        def subcommand new_subcommand
          is_error = !defined?(new_subcommand) || !new_subcommand.is_a?(Class) || !new_subcommand.ancestors.include?(Playwright::Cli::Lib::Base)
          raise ValidationError.new("Subcommand does not exist!") if is_error
          @subcommands.push new_subcommand
        end
      end

      attr_reader :argv

      def initialize(argv = ARGV)
        @runner = Runner.new(self, argv: argv)
      end

      def call
        runner.run
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

      def validate!
        raise ValidationError.new("Root is missing!") if !root
      end
    end
  end
end