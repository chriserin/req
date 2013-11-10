module Req
  module Commands
    class Exec
      def self.setup(context)
        context.desc 'exec JS', 'execute some js on the current webpage'
      end

      def self.run(js)
        Req::EmptyPageDir.create if Req::Dir.latest.nil?
        puts Req::Phantom.run(Req::Dir.latest.path, "exec", js)
      end
    end
  end
end

Req::CLI.command_classes << Req::Commands::Exec
