module Req
  module Commands
    class Compare 
      extend Optionable

      def self.setup(context)
        context.desc 'compare [PATH]', 'compare the current result with the last stored result'
        context.option :ignore_script_tags, :type => :boolean
        context.option :full_stack, :type => :boolean
      end

      def self.run(url=nil)
        Req::Comparison.url(url, options)
      end
    end
  end
end

Req::CLI.command_classes << Req::Commands::Compare
