require 'diffy'

module Req
  class Comparison
    def self.url(url=nil, options)
      session = Req::Session.new(options)
      url ||= Req::Dir.latest.url
      url = "/" if url == "/root"
      session.get URI.encode(url)

      text_a = remove_lines(session.response.body, options)
      text_b = remove_lines(Req::Dir.latest(url).read, options)
      Diffy::Diff.default_format = :color
      puts Diffy::Diff.new(text_a, text_b, :diff => "--suppress-common-lines")
    end

    def self.remove_lines(text, options)
      text = remove_csrf_token(text)
      text = remove_script_tags(text) if options.ignore_script_tags?
      return text
    end

    def self.remove_script_tags(text)
      text.gsub(/^.*script.*src.*$/, '')
    end

    def self.remove_csrf_token(text)
      text.gsub(/^.*meta.*csrf-token.*$/, '')
    end
  end
end
