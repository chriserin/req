page = require('webpage').create();
server = require('webserver').create();
fs = require('fs');
system = require('system');
require("./evalInput.js");
require("./pipes.js");
require("./debugCallbacks.js");
require("./assetServer.js");
require("./arguments.js");
coffee = require("./coffee-script.js").CoffeeScript;

//addDebugCallbacks(page);
phantomArgs = processArguments(system.args);

page.onLoadFinished = function(status) {
  if (option("jquery")) {
    page.includeJs('http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.js', runnerFunc);
  } else {
    runnerFunc();
  }
};

page.onConsoleMessage = function (msg) { console.log(msg); };

runExec = function() {
  if(phantomArgs['js'] && phantomArgs['js'].length > 0){
    toEval = phantomArgs['js']
    result = page.evaluate(evalInput, toEval);
    console.log(rspchars(result))
  }
  phantom.exit(0)
}

runRepl = function() {
  while(true) {
    result = rspchars(page.evaluate(evalInput, compile(fs.read(inPipe))));
    fs.write(outPipe, result, "w");
  }
}

function compile(input) {
  if(option('coffee')) {
    try{
      compiled_input = coffee.compile(input, {bare: true});
      return compiled_input;
    }catch(e){
      console.log(e)
    }
  } else {
    return input;
  }
}

function option(name) {
  return (phantomArgs['options'] && phantomArgs['options'].indexOf(name) >= 0);
}

function rspchars(str) {
  if(str) {
    return str.replace(/\\n/g,"\n").replace(/\\t/g, "  ");
  }
}

runnerFunc = runRepl
if(option("exec")) {
  runnerFunc = runExec
}

hasNoReqDir = function() {
  return phantomArgs['reqDir'] === undefined || phantomArgs['reqDir'] === null || phantomArgs['reqDir'] === '';
}

if(option("jquery") || option("empty_page") || hasNoReqDir()) {
  content = "<html><head></head><body></body></html>"
  page.setContent(content, "file://" + fs.workingDirectory +  "/.req/empty_page/dummy.html");
} else {
  serveAssets(phantomArgs['reqDir'], page, fs, server);
  page.open(encodeURIComponent(phantomArgs['reqDir'] + "/output.html"));
}
