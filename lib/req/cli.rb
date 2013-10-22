require 'thor'
require 'nokogiri'
require 'uri'
require 'diffy'

require 'req/response_format'
require 'req/dir'
require 'req/empty_page_dir'
require 'req/assets'
require 'req/repl'
require 'req/phantom'
require 'req/session'
require 'req/compare'

module Req
  class CLI < Thor
    default_task :get

    desc 'get PATH', 'get the output of a request'
    def get(url)
      session = Req::Session.new
      session.get(url)
      Req::Dir.create(session.request.path).write(session.response.body)
      Req::Assets.acquire_javascripts()
      Req::ResponseFormat.output(session)
    end

    desc 'compare [PATH]', 'compare the current result with the last stored result'
    def compare(url=nil)
      Req::Comparison.url(url)
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
        phantom_pid = Req::Phantom.run_exec(Req::Dir.latest.path, phantom_options, js_string)
        Repl.start
        Process.kill(15, phantom_pid)
      else
        puts Req::Phantom.run(Req::Dir.latest.path, phantom_options, js_string)
      end
    ensure
      Req::EmptyPageDir.remove
    end

    desc 'exec JS', 'execute some js on the current webpage'
    def exec(js)
      Req::EmptyPageDir.create if Req::Dir.latest.nil?
      puts Req::Phantom.run(Req::Dir.latest.path, "exec", js)
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
