



express = require('express')
http = require('http')

app = express()
server = http.createServer(app)
io = require('socket.io').listen(server)
fs = require('fs')

app.get('/', (req, res)->
    fs.readFile(__dirname + '/index.html',
        (err, data)->
            if (err)
                res.writeHead(500)
                return res.end('Error loading index.html')
            res.writeHead(200)
            res.end(data)
    )
)

io.sockets.on('connection', (socket)->
    socket.emit('news', { hello: 'world' })
    socket.on('my other event', (data)->
        console.log(data)
    )
)

server.listen(8000)

