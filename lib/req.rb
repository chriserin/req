
module Req
  require 'thor'
  require 'nokogiri'
  require 'uri'
  require 'diffy'

  def self.command_dirs
    @command_dirs ||= [req_commands_dir]
  end

  def self.req_commands_dir
    File.join(File.expand_path(File.dirname(__FILE__)), "req/commands/")
  end

  require "req/version"
  require 'req/response_format'
  require 'req/dir'
  require 'req/empty_page_dir'
  require 'req/assets'
  require 'req/repl'
  require 'req/phantom'
  require 'req/session'
  require 'req/cli'

  def self.load_plugins
    req_plugins.each {|dep| puts dep.name; puts require dep.name.gsub("-", "/")}
  end

  def self.req_plugins
    Bundler.environment.dependencies.select {|dep| dep.name =~ /req-/}
  end

  load_plugins

  require 'req/commands'
end
