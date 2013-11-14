require 'forwardable'
require 'uri'

module Req
  class Session
    extend Forwardable

    def initialize(options)
      @options = options
      require File.join(::Dir.pwd, '/config/environment')
      Rails.application.config.action_dispatch.show_exceptions = false
      ActionController::Base.instance_eval do
        define_method :protect_against_forgery? do
          false
        end
      end
      @session = ActionDispatch::Integration::Session.new(Rails.application)
    end

    def get(url)
      url = ::URI.encode(url) unless url.include? ?%
      @session.get url
    rescue Object => e
      puts e.message, stack(e)
      exit 1
    end

    def post(url, params)
      url = ::URI.encode(url) unless url.include? ?%
      params = Rack::Utils.parse_nested_query(params)
      @session.post_via_redirect(url, params)
    end

    def stack(e)
      return e.backtrace        if @options.keys.include? "full_stack" and @options.full_stack?
      return e.backtrace[0..10] if @options.keys.include? "ten_stack" and @options.ten_stack?
      return e.backtrace[0]
    end

    def_delegators :@session, :request, :response
  end
end
