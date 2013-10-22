
module Req
  module Assets
    extend self
    def acquire_javascripts()
      session = Req::Session.new
      page = Nokogiri::HTML(open(Req::Dir.latest.output_path))
      node_set = page.css("script[src]")
      node_set.each do |js_tag|
        js_src = js_tag.attributes["src"]
        session.get(js_src)
        Req::Dir.write_asset(js_src.to_s.gsub(/\?.*$/, ""), session.response.body)
      end
    end
  end
end
