util =  require ("util")
io = require("socket.io")
Player = require("../../js/Player").Player


class Server
    init: ()->
        @socket = io.listen 8000
        @socket.configure (()->
            @socket.set "transports", ["websocket"]
            @socket.set "log level", 2).bind this
        @setEventHandlers()
        util.log "Server init()"
    setEventHandlers: () ->
        @socket.sockets.on "connection", @onSocketConnection

    onSocketConnection: (client) ->
        util.log "New Player has connected:"



gameServer = new Server

gameServer.init()
