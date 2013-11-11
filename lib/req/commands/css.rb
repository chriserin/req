module Req
  module Commands
    module Css
      def self.setup(context)
        context.desc 'css SELECTOR', 'get html of the css selector'
      end

      def self.run(selector)
        if Req::Dir.latest.nil?
          puts "no req dir"
        else
          page = Nokogiri::HTML(Kernel::open(Req::Dir.latest.output_path))
          node_set = page.css(selector)
          puts "nothing selected" if node_set.count == 0
          node_set.each do |node|
            puts node.to_s
          end
        end
      end
    end
  end
end

Req::CLI.command_classes << Req::Commands::Css
