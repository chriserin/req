module Req
  module Commands
    class Repl
      extend Optionable

      def self.setup(context)
        context.desc 'repl', 'open js repl in the context of your webpage'
        context.option :empty_page, :type => :boolean
        context.option :jquery, :type => :boolean
        context.option :exec
      end

      def self.run
        phantom_options = options.keys.join(",")
        js_string       = String.new if options.exec == "exec"
        Req::EmptyPageDir.create if options.empty_page? || options.jquery? || Req::Dir.latest.nil?

        if options["exec"].nil?
          Req::Repl.create_phantom_pipe
          loop do
            phantom_pid = Req::Phantom.run_exec(Req::Dir.latest.path, phantom_options, js_string)
            next_action = Req::Repl.start
            Process.kill(15, phantom_pid)
            break if next_action == :break
            Req::Assets.acquire_javascripts if next_action == :reload
          end
        else
          puts Req::Phantom.run(Req::Dir.latest.path, phantom_options, js_string)
        end
      ensure
        Req::EmptyPageDir.remove
      end
    end
  end
end

Req::CLI.command_classes << Req::Commands::Repl
