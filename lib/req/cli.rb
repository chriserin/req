module Req
  class CLI < Thor
    def self.make_commands
      command_classes.each do |klass|
        klass.setup(self)
        define_method command_name(klass) do |*args|
          klass.options = options if Req::Commands::Optionable === klass
          klass.run(*args)
        end
      end
    end

    def self.command_name(klass)
      klass.name.split('::').last.downcase
    end

    def self.start(given_args=ARGV, config={})
      make_commands
      super
    end

    def self.command_classes
      @command_classes ||= []
    end
  end
end
