
callbacks = {
  onLoadFinished: function(status) {
  },
  onResourceReceived: function(response) {
    system.stderr.writeLine('= onResourceReceived()' );
    system.stderr.writeLine('  id: ' + response.id + ', stage: "' + response.stage + '", response: ' + JSON.stringify(response));
  },
  onLoadStarted: function() {
    system.stderr.writeLine('= onLoadStarted()');
    var currentUrl = page.evaluate(function() {
      return window.location.href;
    });
    system.stderr.writeLine('  leaving url: ' + currentUrl);
  },
  onNavigationRequested: function(url, type, willNavigate, main) {
    system.stderr.writeLine('= onNavigationRequested');
    system.stderr.writeLine('  destination_url: ' + url);
    system.stderr.writeLine('  type (cause): ' + type);
    system.stderr.writeLine('  will navigate: ' + willNavigate);
    system.stderr.writeLine('  from page\'s main frame: ' + main);
  },
  onResourceError: function(resourceError) {
    system.stderr.writeLine('= onResourceError()');
    system.stderr.writeLine('  - unable to load url: "' + resourceError.url + '"');
    system.stderr.writeLine('  - error code: ' + resourceError.errorCode + ', description: ' + resourceError.errorString );
  },
  onResourceRequested: function(request, networkCall) {
    system.stderr.writeLine('= onRequestRequested()');
    system.stderr.writeLine(request);
  }
}

addDebugCallbacks = function(page){
  if (true) {
    for (cb in callbacks) {
      page[cb] = callbacks[cb]
    }
  }

  page.onError = function(msg, trace) {
    var msgStack = ['  ERROR: ' + msg];
    if (trace && false) {
      msgStack.push('  TRACE:');
      trace.forEach(function(t) {
        msgStack.push('    -> ' + t.file + ': ' + t.line + (t.function ? ' (in function "' + t.function + '")' : ''));
      });
    }
    system.stderr.writeLine(msgStack.join('\n'));
  };
}
