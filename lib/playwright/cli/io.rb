require 'colorize'

module Playwright
  module Cli
    module Io
      def io
        @io = IoClass.new
      end
    end
    class IoClass
      ASK_TYPES = %i(boolean bool string str)
      def say msg
        $stdout.print "#{msg}\n".cyan.bold
      end

      def ask msg, type: :boolean, default: false, inline: false
        raise ValidationError.new("Invalid type") if !ASK_TYPES.include?(type)
        case type
        when :boolean, :bool
          ask_bool msg, default: default, inline: inline
        when :string, :string
          ask_string msg, default: default, inline: inline
        end
      end

      def warn msg
        $stdout.print "#{msg}\n".yellow.bold
      end

      def error msg
        $stdout.print "#{msg}\n".red.bold
      end

      private

      def ask_bool msg, default:, inline:
        msg += default ? " [Yn] " : " [yN] "
        msg += inline ? " " : "\n"
        $stdout.print msg.yellow
        response = $stdin.gets.strip
        return true if response.downcase == "y"
        return false if response.downcase == "n"
        default
      end

      def ask_string msg, default:, inline:
        msg += " [default: '#{default}']" if default
        msg += inline ? " " : "\n"
        $stdout.print msg.yellow
        $stdin.gets.strip
      end
    end
  end
end
