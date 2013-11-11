module Req
  module Commands
    class Latest
      def self.setup(context)
        context.desc 'latest', 'get the latest req dir'
        context.option :output
      end

      def self.run
        if options["output"]
          puts File.read(Req::Dir.output_path)
        else
          latest_dir = Req::Dir.latest
          if latest_dir.nil?
            puts "no req directories"
          else
            puts latest_dir.path
          end
        end
      end
    end
  end
end

Req::CLI.command_classes << Req::Commands::Latest
