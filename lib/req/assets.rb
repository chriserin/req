
module Req
  module Assets
    extend self
    def acquire_javascripts()
      session = Req::Session.new({})
      page = Nokogiri::HTML(open(Req::Dir.latest.output_path))
      node_set = page.css("script[src]")
      node_set.each do |js_tag|
        js_src = js_tag.attributes["src"]
        session.get(js_src.to_s)
        Req::Dir.latest.write_asset(js_src.to_s.gsub(/\?.*$/, ""), session.response.body)
      end
    end

    def get_javascript(js_url)
      session = Req::Session.new({})
      session.get(js_url.to_s)
      session.response.body
    end

    def allow_js_requests
      puts "allow_js_requests"
      request, response = create_asset_pipes
      child_pid = fork {
        loop do
          js_url = IO.read(request)
          puts "got js_url " + js_url.to_s
          js = get_javascript(js_url)
          puts js
          IO.write(response, js)
        end
      }
      puts "CHILD PID " + child_pid.to_s
      yield
    ensure
      Process.kill("TERM", child_pid)
      FileUtils.rm(request)
      FileUtils.rm(response)
    end

    def create_asset_pipes
      Req::Dir.make_home_dir
      in_pipe_name = File.join(Req::Dir.home, "asset_pipe_request")
      out_pipe_name = File.join(Req::Dir.home, "asset_pipe_response")
      `mkfifo #{in_pipe_name} #{out_pipe_name} 2> /dev/null`
      return in_pipe_name, out_pipe_name
    end
  end
end
