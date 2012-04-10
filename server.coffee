url       = require('url')
bricks    = require('bricks')
servitude = require('servitude')

mimes     = {
  'txt': 'text/plain'
  'json': 'application/json'
}

codes = (req, res)->
  path = url.parse(req.url).pathname.toString().replace(/^\//, '')
  code = path.replace(/\..*$/, '')
  type = path.replace(/[^\.]+\./, '')
  if mime = mimes[type]
    res.setHeader('Content-Type', mime)
  else
    res.setHeader('Content-Type', "text/#{type}")
  res.statusCode(code)
  res.end()

appServer = new bricks.appserver()
appServer.addRoute("/servitude/(.+)", servitude, basedir: "./servitude")
appServer.addRoute(".+", codes)
appServer.addRoute(".+", appServer.plugins.errorhandler, section: 'final')

server = appServer.createServer()
server.listen process.env.PORT || 3000
