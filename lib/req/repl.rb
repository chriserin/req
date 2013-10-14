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
    def start
      pipe_in, pipe_out = Req::Dir.create_phantom_pipe
      loop do
        command = prompt.gets
        break if command.strip == "exit"
        File.open(pipe_in, "w+") do |pipe|
          pipe.write(command)
          pipe.flush
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
