module Req
  module Commands
    class Latest
      extend Optionable

      def self.setup(context)
        context.desc 'latest', 'get the latest req dir'
        context.option :output, :type => :boolean
        context.option :headers, :type => :boolean
      end

      def self.run(url=nil)
        latest_dir = Req::Dir.latest(url)
        if options.output?
          puts latest_dir.read
        elsif options.headers?
          latest_dir.read_headers.each {|k, v| puts "--#{k}=#{v}"}
        else
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
