require 'fileutils'
require 'pathname'

module Req
  module Dir
    extend self
    def home
      ".req"
    end

    def make_home_dir
      FileUtils.mkdir(home) unless File.exists?(home)
    end

    def write_session(path, body)
      File.open(File.join(create_session_dir(path), "output.html"), "w") do
        |output_file| output_file.write(body)
      end
    end

    def create_session_dir(path="/")
      path = "root" if path == "/"
      create_dir(File.join(home, path, "req-#{rand(36**8).to_s(36)}"))[0]
    end

    def create_dir(dir)
      FileUtils.mkdir_p(dir)
    end

    def remove_empty_page_dir
      FileUtils.rm_rf(empty_page_dir)
    end

    def make_empty_page_dir
      remove_empty_page_dir
      create_dir(empty_page_dir)
      create_session_dir("empty_page")
    end

    def empty_page_dir
      File.join(home, "empty_page")
    end

    def create_phantom_pipe
      make_home_dir
      in_pipe_name = File.join(home, "js_repl_in.pipe")
      out_pipe_name = File.join(home, "js_repl_out.pipe")
      `mkfifo #{in_pipe_name} #{out_pipe_name} 2> /dev/null`
      return in_pipe_name, out_pipe_name
    end

    def create_output_pipe
      out_pipe_name = File.join(home, "js_repl_out.pipe")
      return out_pipe_name
    end

    def latest_request_dir
      ::Dir[".req/**/req-*"].sort_by {|dir| File.stat(dir).ctime }.last
    end

    def session_output_path
      File.join(latest_request_dir, "output.html")
    end

    class << self
      alias output_path session_output_path
    end

    def write_asset(asset_path, asset_content)
      dirname = Pathname.new(asset_path).dirname
      session_dir = latest_request_dir
      FileUtils.mkdir_p(File.join(session_dir, dirname))
      File.open(File.join(session_dir, asset_path), "w") do |file|
        file.write(asset_content)
      end
    end
  end
end
