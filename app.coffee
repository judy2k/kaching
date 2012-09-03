PORT = 8000

fs = require('fs')
express = require('express')
http = require('http')
url = require('url')

app = express()
server = http.createServer(app)
io = require('socket.io').listen(server)

# Configuration:
app.engine('html', require('ejs').renderFile);
app.set('views', __dirname + '/views');
app.set('view engine', 'html');

# Utility Methods:
kaching = ->
    if io.rooms['/kaching']
        for clientId in io.rooms['/kaching']
            io.sockets.socket(clientId).emit('kaching', {})

# URL Endpoints:
app.use('/static', express.static(__dirname + '/static'));
app.get('/', (req, res)->
    res.render('index',
        # TODO: This is unlikely to work when behind a proxy.
        host: req.host + ':' + PORT
    )
)
app.get('/kaching', (req, res)->
    res.writeHead(200)
    res.end()
    kaching()
)

io.sockets.on('connection', (socket)->
    socket.join('kaching')
)

# IRC Stuff ------------------------------------------------------------------
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

# Bootstrap ------------------------------------------------------------------
server.listen(PORT)

