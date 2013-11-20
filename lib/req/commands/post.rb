module Req
  module Commands
    class Post
      extend Optionable

      def self.setup(context)
        context.desc "post", "post"
      end

      def self.run(url, params="")
        session = Req::Session.new options, {}
        session.post(url, params)
        reqdir = Req::Dir.create(url)
        reqdir.write(session.response.body)
        reqdir.write_headers(session.response.headers)
        Req::Assets.acquire_javascripts()
        Req::ResponseFormat.output(session)
        repl if options.repl?
      end
    end
  end
end

Req::CLI.command_classes << Req::Commands::Post
