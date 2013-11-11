module Req
  module Commands
    class Post
      def self.setup(context)
        context.desc "post", "post"
      end

      def self.run
        puts "post"
      end
    end
  end
end

Req::CLI.command_classes << Req::Commands::Post
