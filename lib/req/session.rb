require 'forwardable'
require 'uri'

module Req
  class Session
    extend Forwardable

    def initialize
      require File.join(::Dir.pwd, '/config/environment')
      @session = ActionDispatch::Integration::Session.new(Rails.application)
    end

    def get(url)
      @session.get ::URI.encode(url)
    end

    def_delegators :@session, :request, :response
  end
end
