class Server
    constructor: ()->
        @util =  require ("util")
        @io = require("socket.io")
        @Character = require("./Character").Character
        @init()

    init: ()->
        @socket = @io.listen 8000
        @socket.configure ()->
            this.set "transports", ["websocket"]
            this.set "log level", 2

        @setEventHandlers()

    setEventHandlers: () ->
        @socket.sockets.on "connection", @onSocketConnection.bind this

    onSocketConnection: (client) ->
        @util.log "New Player has connected:" + client.id
        client.on "new player", @onNewPlayer.bind this

    onNewPlayer: (data) ->
        @util.log 'New Player Location:' +  data.x + "," + data.y
        # Create new player instance

        newPlayer = new @Character data.id, data.x, data.y
        @socket.sockets.emit "new player", {id: data.id, x:data.x, y:data.y}

gameServer = new Server
