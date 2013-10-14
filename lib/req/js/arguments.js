

processArguments = function(systemArgs) {
  phantomArgs = {}
  for(i = 1; i < systemArgs.length; i++) {
    var arg = systemArgs[i]
    var key = split(arg)[0]
    var value = split(arg)[1]
    phantomArgs[key] = value
  }
  return phantomArgs;
}

split = function(arg) {
  idx = arg.indexOf('=');
  return [arg.slice(0,idx), arg.slice(idx+1)];
}
