module Req
  module Commands
    require 'req/commands/optionable'

    Req::command_dirs.each do |dir|
      ::Dir.entries(dir).each do |file|
        require File.join(dir, file) if file =~ /\.rb$/
      end
    end
  end
end
