class window.Game
    constructor: ->
        @Y_AXIS_THREASHOLD = 30; # hit detection of y axis threashold in pixels

    init: ->
        @keysDown = {}
        @players = []

        @stageInit()
        @serverInit()

        createjs.Ticker.setFPS 60
        createjs.Ticker.addEventListener "tick", @stage
        @ready = false


        @lastKeyPress = new Date()


        @addEventHandlers()


    # Server setup
    serverInit: () ->
        @socket = io.connect "http://192.168.1.129", {port: 8000, transports: ["websocket"]}
        console.log @socket


    # Stage setup
    stageInit: () ->
        @rect = new createjs.Rectangle 0, 0, 100, 100
        # Setup Stage
        @stage = new createjs.Stage document.getElementById("gameCanvas")
        background = new createjs.Graphics().beginFill("#000000").drawRect 0, 0, @stage.canvas.width, @stage.canvas.height
        shape = new createjs.Shape background
        shape.x = 0
        shape.y = 0
        @stage.addChild shape
        @hud = new Hud @players, @stage.canvas.width, 100, @stage

        @arena = new Arena @stage.canvas.width, (@stage.canvas.height - 100), @players
        @arena.setPosition 0, 100
        @arena.addToStage @stage


    addEventHandlers: () ->

        @socket.on "connect", @onConnected.bind this
        @socket.on "new player", @onNewPlayer.bind this
        @socket.on "client id", @onReceivedClientID.bind this

        @socket.on "update", @onUpdate.bind this


    # Handlers for events

    onUpdate: (data) ->
        if (data.id != @clientID)
                console.log 'update'
                updatePlayer = @playerGet (data.id)

                updatePlayer.x = data.x
                updatePlayer.y = data.y
                updatePlayer.run data.dir
    # Connected to Server
    onConnected: () ->

    # Received client ID from the server
    onReceivedClientID: (data) ->
        # Send local player to server
        @socket.emit "new player", {id:data.id,x:250, y:250}

        @clientID = data.id

    # New player has joined ( This include the local)
    onNewPlayer: (data) ->
        if !(@playerExists data.id)
            console.log 'Add new player to stage ' + data.id
            c = new Character "firzen", "assets/spritesheets/firzen.png", 5, data.x, data.y
            c.id = data.id
            @arena.addPlayer c
            @players.push c

        console.log 'player list'
        console.log @players
        console.log 'New Player'
        console.log data
        if (data.id == @clientID)
            console.log 'My Character'
            createjs.Ticker.addEventListener "tick", ((evt) ->
                if (@keysDown[Constant.KEYCODE_RIGHT])
                    c.run 'right'
                    @socket.emit "update", {id:@clientID, x:c.x, y:c.y, dir:"right"}
                    console.log "new Coord" + @playerGet(@clientID).x + "," + c.y
                if (@keysDown[Constant.KEYCODE_LEFT])
                    c.run 'left'
                    @socket.emit "update", {id:@clientID, x:c.x, y:c.y, dir:"left"}

                if (@keysDown[Constant.KEYCODE_DOWN])
                    @socket.emit "update", {id:@clientID, x:c.x, y:c.y, dir:"down"}
                    c.run 'down'

                if (@keysDown[Constant.KEYCODE_UP])

                    @socket.emit "update", {id:@clientID, x:c.x, y:c.y, dir:"up"}
                    c.run 'up'
                    console.log "new Coord" + @playerGet(@clientID).x + "," + c.y

                if (@keysDown[Constant.KEYCODE_Z])
                    c.attack()
                    if (collide @enemy.getRect(), c.getRect())
                        @enemy.gotHit()
                        @enemy.setState "hurt"

            ).bind this


            window.addEventListener "keydown", ((e) ->
                @keysDown[e.keyCode] = true
            ).bind this

            window.addEventListener "keyup", ((e) ->
                @keysDown[e.keyCode] = false
                if (!@keysDown[Constant.KEYCODE_RIGHT] && !@keysDown[Constant.KEYCODE_LEFT] && !@keysDown[Constant.KEYCODE_UP] && !@keysDown[Constant.KEYCODE_DOWN])
                    if (c.character.currentAnimation == "run")
                        c.idle()
                    c.setState 'idle'
            ).bind this

        else

    # Check if player already exists
    playerExists: (id) ->
        for p in @players
            if (p.id == id)
                return true
        return false


    playerGet: (id) ->
        for p in @players
            if (p.id == id)
                return p

    # Check if 2 rectangles intersect
    collide: (rect1, rect2) ->
        console.log 'rect1 ' + rect1.y2
        console.log 'rect2 ' + rect2.y2
        console.log (!(rect2.x2 < rect1.x1) && !(rect2.x1 > rect1.x2))
        console.log  (rect1.y2 - @Y_AXIS_THREASHOLD)
        console.log (rect1.y2 + @Y_AXIS_THREASHOLD)
        return (!(rect2.x2 < rect1.x1) && !(rect2.x1 > rect1.x2) && (rect2.y2 > (rect1.y2 - @Y_AXIS_THREASHOLD)) && (rect2.y2 < (rect1.y2 + @Y_AXIS_THREASHOLD)))

