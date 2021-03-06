module MotionBundler
  module Simulator
    module Console

      class Warning
        def print
          if require_statement = [:require, :require_relative, :load, :autoload].include?(@method)
            return if MotionBundler::REQUIRED.include? @args.last
          end

          warning = "Warning Called `#{[@object, @method].compact.join "."}"
          warning += " #{@args.collect(&:inspect).join ", "}" unless @args.nil? || @args.empty?
          warning += "`"
          warning = warning.yellow

          if require_statement
            warning += "\nAdd within setup block: ".yellow
            warning += "app.require \"#{@args.last}\"".green
          elsif @message
            warning += "\n#{@message}".green
          end

          puts "   #{warning.gsub("\n", "\n" + (" " * 11))}"
        end
      private
        def require(*args)
          @method = :require
          @args = args
          @method
        end
        def require_relative(*args)
          @method = :require_relative
          @args = args
        end
        def load(*args)
          @method = :load
          @args = args
        end
        def autoload(*args)
          @method = :autoload
          @args = args
        end
        def call(object, method)
          @object = object
          @method = method
        end
        def message(message)
          @message = message
        end
      end

      def self.warn(&block)
        warning = Warning.new
        warning.instance_eval &block
        warning.print
      end

    end
  end
end