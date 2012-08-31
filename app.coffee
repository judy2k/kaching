fs = require('fs')
express = require('express')
http = require('http')
url = require('url')

app = express()
server = http.createServer(app)
io = require('socket.io').listen(server)

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

app.use('/static', express.static(__dirname + '/static'));
app.get('/chink', (req, res)->
    res.writeHead(200)
    res.end()

    params = url.parse(req.url, true).query
    if io.rooms['/chink']
        for clientId in io.rooms['/chink']
            io.sockets.socket(clientId).emit('chink', {})
)

io.sockets.on('connection', (socket)->
    socket.emit('news', { hello: 'world' })
    socket.on('my other event', (data)->
        console.log(data)
    )
    socket.join('chink')
)

server.listen(8000)

