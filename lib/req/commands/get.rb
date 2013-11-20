module Req
  module Commands
    class Get
      extend Optionable

      def self.setup(context)
        context.desc 'get PATH', 'get the output of a request'
        context.option :repl, :type => :boolean
        context.option :full_stack, :type => :boolean
        context.option :ten_stack, :type => :boolean
        context.option :with_cookies, :type => :string
      end

      def self.run(url)
        request_headers = {}
        request_headers = get_cookies(options, request_headers)
        session = Req::Session.new options, request_headers
        session.get(url)
        reqdir = Req::Dir.create(session.request.path)
        reqdir.write(session.response.body)
        reqdir.write_headers(session.response.headers)
        Req::Assets.acquire_javascripts()
        Req::ResponseFormat.output(session)
        repl if options.repl?
      end

      def self.get_cookies(options, headers)
        return headers unless options[:with_cookies]
        cookies_dir = Req::Dir.latest(options[:with_cookies])
        cookies = cookies_dir.read_headers["Set-Cookie"]
        headers["Cookie"] = cookies
        return headers
      end
    end
  end
end

Req::CLI.command_classes << Req::Commands::Get
