serveAssets = function(reqDir, page, fs, server) {
  var listening = server.listen("4242", function (request, response) {
    response.statusCode = 200;
    response.headers = {"Cache": "no-cache", "Content-Type": "text/javascript"};
    response.setHeader("foo", "bar");
    response.write(fs.read(reqDir + request.url));
    response.close();
  });

  page.onResourceRequested = function (request, networkRequest) {
    if(request.url.indexOf(".js") > 0) {
      asset_path = request.url.replace("file:///", "").replace(/\?.*$/, "")
      networkRequest.changeUrl("http://localhost:4242/" + asset_path)
    }
  }
}
