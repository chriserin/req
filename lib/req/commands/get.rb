module Req
  module Commands
    class Get
      extend Optionable

      def self.setup(context)
        context.desc 'get PATH', 'get the output of a request'
        context.option :repl, :type => :boolean
        context.option :full_stack, :type => :boolean
        context.option :ten_stack, :type => :boolean
      end

      def self.run(url)
        session = Req::Session.new options
        session.get(url)
        reqdir = Req::Dir.create(session.request.path)
        reqdir.write(session.response.body)
        reqdir.write_headers(session.response.headers)
        Req::Assets.acquire_javascripts()
        Req::ResponseFormat.output(session)
        repl if options.repl?
      end
    end
  end
end

Req::CLI.command_classes << Req::Commands::Get
