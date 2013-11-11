
module Req
  require 'thor'
  require 'nokogiri'
  require 'uri'
  require 'diffy'

  require "req/version"
  require 'req/response_format'
  require 'req/dir'
  require 'req/empty_page_dir'
  require 'req/assets'
  require 'req/repl'
  require 'req/phantom'
  require 'req/session'
  require 'req/compare'
  require 'req/rest'
  require 'req/cli'
  require 'req/commands'
end
