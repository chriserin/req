
module Req
  module ResponseFormat
    extend self
    def output(session)
      case session.response.status
      when 200 then puts session.response.body
      when 404 then print session.response.body
      when 500 then print session.response.body
      else
        puts session.response.body
      end
    end
  end
end
