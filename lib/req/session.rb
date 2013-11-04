require 'forwardable'
require 'uri'

module Req
  class Session
    extend Forwardable

    def initialize(options)
      @options = options
      require File.join(::Dir.pwd, '/config/environment')
      Rails.application.config.action_dispatch.show_exceptions = false
      @session = ActionDispatch::Integration::Session.new(Rails.application)
    end

    def get(url)
      @session.get ::URI.encode(url)
    rescue Object => e
      puts e.message, stack(e)
      exit 1
    end

    def stack(e)
      return e.backtrace        if @options.full_stack?
      return e.backtrace[0..10] if @options.ten_stack?
      return e.backtrace[0]
    end

    def_delegators :@session, :request, :response
  end
end
