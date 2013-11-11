
module Req
  class CLI < Rest

    def self.make_commands
      command_classes.each do |klass|
        klass.setup(self)
        define_method command_name(klass) do |args|
          klass.options = options if Req::Commands::Optionable === klass
          klass.run(args)
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

    desc 'repl', 'open js repl in the context of your webpage'
    option :empty_page, :type => :boolean
    option :jquery, :type => :boolean
    option :exec
    def repl()
      phantom_options = options.keys.join(",")
      js_string       = String.new if options.exec == "exec"
      Req::EmptyPageDir.create if options.empty_page? || options.jquery? || Req::Dir.latest.nil?

      if options["exec"].nil?
        Req::Repl.create_phantom_pipe
        loop do
          phantom_pid = Req::Phantom.run_exec(Req::Dir.latest.path, phantom_options, js_string)
          next_action = Repl.start
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

    desc 'css SELECTOR', 'get html of the css selector'
    def css(selector)
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

    desc 'latest', 'get the latest req dir'
    option :output
    def latest
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
