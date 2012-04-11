url       = require('url')
bricks    = require('bricks')
servitude = require('servitude')

mimes     = {
  'txt': 'text/plain'
  'json': 'application/json'
  'xml': 'application/xml'
}

codes = (req, res)->
  path = url.parse(req.url).pathname.toString().replace(/^\//, '')
  code = path.replace(/\..*$/, '')
  type = if path.indexOf('.') >= 0 then path.replace(/[^\.]+\./, '') else null
  if type
    if mime = mimes[type]
      res.setHeader('Content-Type', mime)
    else
      res.setHeader('Content-Type', "text/#{type}")
      res.write(code)
  else
    res.setHeader('Content-Type', "text/html")
    res.write(code)

  switch type
    when 'xml'
      res.write("<code>#{code}</code>")
    when 'json'
      res.write("{\"code\":\"#{code}\"}")
    when 'txt'
      res.write(code)

  res.statusCode(code)
  res.end()

appServer = new bricks.appserver()
appServer.addRoute("/servitude/(.+)", servitude, basedir: "./servitude")
appServer.addRoute(".+", codes)
appServer.addRoute(".+", appServer.plugins.errorhandler, section: 'final')

server = appServer.createServer()
server.listen process.env.PORT || 3000
