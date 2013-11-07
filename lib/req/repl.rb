require 'irb/locale'
require 'irb/input-method'

module IRB
  def self.conf
    { LC_MESSAGES: Locale.new }
  end
end

module Req
  module Repl
    extend self

    def create_phantom_pipe
      Req::Dir.make_home_dir
      in_pipe_name = File.join(Req::Dir.home, "js_repl_in.pipe")
      out_pipe_name = File.join(Req::Dir.home, "js_repl_out.pipe")
      `mkfifo #{in_pipe_name} #{out_pipe_name} 2> /dev/null`
      return in_pipe_name, out_pipe_name
    end


    def start
      pipe_in, pipe_out = create_phantom_pipe
      loop do
        Req::Assets.allow_js_requests do
          command = prompt.gets
          return if command.strip == "exit"
          File.open(pipe_in, "w+") do |pipe|
            pipe.write(command)
            pipe.flush
          end
        end
        puts IO.read(pipe_out)
      end
    end

    def prompt
      @io ||= IRB::ReadlineInputMethod.new.tap do |new_io|
        new_io.prompt = "> "
      end
    end
  end
end
