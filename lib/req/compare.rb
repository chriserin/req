require 'diffy'

module Req
  class Comparison
    def self.url(url=nil)
      session = Req::Session.new
      url ||= Req::Dir.latest.url
      session.get URI.encode(url)

      text_a = remove_csrf_token(session.response.body)
      text_b = remove_csrf_token(Req::Dir.latest(url).read)
      Diffy::Diff.default_format = :color
      puts Diffy::Diff.new(text_a, text_b, :diff => "--suppress-common-lines")
    end

    def self.remove_csrf_token(text)
      text.gsub(/^.*meta.*csrf-token.*$/, '')
    end
  end
end
