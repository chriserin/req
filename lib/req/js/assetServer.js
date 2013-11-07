serveAssets = function(reqDir, page, fs, server) {
  var listening = server.listen("4242", function (request, response) {
    response.statusCode = 200;
    response.headers = {"Cache": "no-cache", "Content-Type": "text/javascript"};
    try {
      assetPath = reqDir + request.url.replace(/\?.*$/, "");
      if (fs.exists(assetPath)){
        response.write(fs.read(assetPath));
      } else if (fs.exists('./.req/asset_pipe_request')) {
        fs.write('./.req/asset_pipe_request', request.url);
        data = fs.read('./.req/asset_pipe_response')
        console.log(data)
        response.write(data)
      } else {
        console.log(request.url + " not loaded")
      }
    } catch (err) {
      console.log("caught error")
      console.log(err)
    }
    response.close();
  });

  console.log(listening)

  page.onResourceRequested = function (request, networkRequest) {
    if(request.url.indexOf(".js") > 0) {
      assetPath = request.url.replace("file:///", "")
      networkRequest.changeUrl("http://localhost:4242/" + assetPath)
    }
  }
}
