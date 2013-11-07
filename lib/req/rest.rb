module Req
  class Rest < Thor
    class << self
      def default_rest_options
        option :full_stack, :type => :boolean
        option :ten_stack, :type => :boolean
      end
    end
    default_task :get

    desc "post URL", "create a post request to the rails application"
    default_rest_options
    def post
      puts "post again"
    end

    desc 'get PATH', 'get the output of a request'
    default_rest_options
    option :repl, :type => :boolean
    def get(url)
      session = Req::Session.new options
      session.get(url)
      Req::Dir.create(session.request.path).write(session.response.body)
      Req::Assets.acquire_javascripts()
      Req::ResponseFormat.output(session)
      repl if options.repl?
    end

  end
end
