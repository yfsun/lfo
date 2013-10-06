class Server
    constructor: ()->
        @util =  require ("util")
        @io = require("socket.io")
        @Character = require("./character.js").Character

        @players = []
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
        @util.log client.id
        client.emit "client id", {id:client.id}

        # Send the client its ID
        client.on "new player", @onNewPlayer.bind this

        client.on "update", @onSocketUpdate.bind this
        # Send the existing players to the client
        for player in @players
                client.emit "new player", {id: player.id, x:player.x, y:player.y}
                @util.log 'emitting existing player:' + player.id

    onNewPlayer: (data) ->
        @util.log 'New Player:' +  data.id + '--- Location:' + data.x + ',' + data.y
        # Create new player instance

        @players.push {id:data.id, x:data.x, y:data.y}
        @socket.sockets.emit "new player", {id: data.id, x:data.x, y:data.y}

    onSocketUpdate: (data) ->
        @util.log "update: id:" + data.id + " x:" + data.x + " y:" + data.y

        # Broadcast all updates
        @socket.sockets.emit "update", {id:data.id, x:data.x, y:data.y, dir:data.dir}

gameServer = new Server
