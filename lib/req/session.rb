require 'forwardable'
require 'uri'

module Req
  class Session
    extend Forwardable

    def initialize
      require File.join(::Dir.pwd, '/config/environment')
      Rails.application.config.action_dispatch.show_exceptions = false
      @session = ActionDispatch::Integration::Session.new(Rails.application)
    end

    def get(url)
      @session.get ::URI.encode(url)
    end

    def_delegators :@session, :request, :response
  end
end
