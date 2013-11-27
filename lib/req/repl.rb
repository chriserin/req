require 'easy_repl'

module Req
  class Repl
    include EasyRepl::Repl
    EasyRepl.history_file = ".reqrc_history"

    def initialize(phantom_options, js_string)
      @phantom_options, @js_string = phantom_options, js_string
    end

    def setup
      @pipe_in, @pipe_out = create_phantom_pipe
      @phantom_pid = Req::Phantom.run_exec(Req::Dir.latest.path, @phantom_options, @js_string)
    end

    def teardown
      Process.kill(15, @phantom_pid)
    end

    def before_input
      @asset_server = Req::AssetServer.start
    end

    def after_input
      @asset_server.close
    end

    def create_phantom_pipe
      Req::Dir.make_home_dir
      in_pipe_name = File.join(Req::Dir.home, "js_repl_in.pipe")
      out_pipe_name = File.join(Req::Dir.home, "js_repl_out.pipe")
      `mkfifo #{in_pipe_name} #{out_pipe_name} 2> /dev/null`
      return in_pipe_name, out_pipe_name
    end

    def process_input(input)
      File.open(@pipe_in, "w+") do |pipe|
        pipe.write(input)
        pipe.flush
      end
      puts IO.read(@pipe_out)
    end
  end
end
