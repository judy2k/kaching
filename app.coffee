fs = require('fs')
express = require('express')
http = require('http')
url = require('url')

app = express()
server = http.createServer(app)
io = require('socket.io').listen(server)

kaching = ->
    if io.rooms['/kaching']
        for clientId in io.rooms['/kaching']
            io.sockets.socket(clientId).emit('kaching', {})

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
app.get('/kaching', (req, res)->
    res.writeHead(200)
    res.end()
    kaching()
)

io.sockets.on('connection', (socket)->
    # socket.emit('news', { hello: 'world' })
    # socket.on('my other event', (data)->
    #     console.log(data)
    # )
    socket.join('kaching')
)

irc = require('irc');
client = new irc.Client('irc.freenode.net', 'tempbot',
    autoConnect: false
);
client.connect(->
    client.join('#tempbot')
)
client.addListener('message', (from, to, message)->
    if message.toLowerCase().indexOf('kaching') > -1
        kaching()
);

server.listen(8000)

