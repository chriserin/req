module Req
  module Phantom
    extend self
    COMMAND = "phantomjs"
    FILE = "./lib/req/js/phantom.js"
    def run_exec(reqDir, options="", js="")
      cmd = construct_cmd(reqDir, options, js)
      return fork { exec(cmd) }
    end

    def run(reqDir, options="", js="")
      `#{construct_cmd(reqDir, options, js)}`
    end

    def construct_cmd(reqDir, options, js)
      [
        COMMAND,
        FILE,
        keyval("reqDir", reqDir),
        keyval("options", options),
        keyval("js", js)
      ].join(" ")
    end

    def keyval(key, val)
      "#{key}=#{val}"
    end
  end
end
