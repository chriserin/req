require 'thor'
require 'nokogiri'

require 'req/response_format'
require 'req/dir'
require 'req/assets'
require 'req/repl'
require 'req/phantom'

module Req
  class CLI < Thor
    default_task :get

    desc 'get PATH', 'get the output of a request'
    def get(path)
      require File.join(::Dir.pwd, '/config/environment')
      session = ActionDispatch::Integration::Session.new(Rails.application)
      session.get URI.encode(path)
      Req::Dir.write_session(session.request.path, session.response.body)
      Req::ResponseFormat.output(session)
      Req::Assets.acquire_javascripts()
    end

    desc 'repl', 'open js repl in the context of your webpage'
    option :empty_page, :type => :boolean
    option :jquery, :type => :boolean
    option :exec
    def repl()
      phantom_options = options.keys.join(",")
      js_string       = String.new if options.exec == "exec"
      Req::Dir.make_empty_page_dir if options.empty_page? || options.jquery?

      if options["exec"].nil?
        Req::Dir.create_phantom_pipe
        phantom_pid = Req::Phantom.run_exec(Req::Dir.latest_request_dir, phantom_options, js_string)
        Repl.start
        Process.kill(15, phantom_pid)
      else
        puts Req::Phantom.run(Req::Dir.latest_request_dir, phantom_options, js_string)
      end
    ensure
      Req::Dir.remove_empty_page_dir
    end

    desc 'exec JS', 'execute some js on the current webpage'
    def exec(js)
      puts Req::Phantom.run(Req::Dir.latest_request_dir, "exec", js)
    end

    desc 'css SELECTOR', 'get html of the css selector'
    def css(selector)
      if Req::Dir.latest_request_dir.nil?
        puts "no req dir"
      else
        page = Nokogiri::HTML(open(Req::Dir.output_path))
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
        latest_dir = Req::Dir.latest_request_dir
        if latest_dir.nil?
          puts "no req directories"
        else
          puts latest_dir
        end
      end
    end
  end
end
