class window.Game
    constructor: ->
        @Y_AXIS_THREASHOLD = 30; # hit detection of y axis threashold in pixels

    init: ->
        @rect = new createjs.Rectangle 0, 0, 100, 100
        @keysDown = {}
        @players = []
        # Setup Stage
        @stage = new createjs.Stage document.getElementById("gameCanvas")
        background = new createjs.Graphics().beginFill("#000000").drawRect 0, 0, @stage.canvas.width, @stage.canvas.height
        shape = new createjs.Shape background
        shape.x = 0
        shape.y = 0
        @stage.addChild shape

        @socket = io.connect "http://localhost", {port: 8000, transports: ["websocket"]}

        console.log @socket

        @c = new Character "firzen", "assets/spritesheets/firzen.png", 5, 250, 100
        @enemy = new Character 'firzen', "assets/spritesheets/firzen.png", 5, 400, 100


        @c.addToStage @stage
        @enemy.addToStage @stage


        @players.push @c
        @players.push @enemy


        @hud = new Hud @players, @stage.canvas.width, 100, @stage

        @arena = new Arena @stage.canvas.width, (@stage.canvas.height - 100), @players
        @arena.setPosition 0, 100

        @arena.addToStage @stage


        createjs.Ticker.setFPS 60
        createjs.Ticker.addEventListener "tick", @stage
        @ready = false


        @lastKeyPress = new Date()
        console.log stage

        @attackQueue = []

        createjs.Ticker.addEventListener "tick", ((evt) ->
            if (@keysDown[Constant.KEYCODE_RIGHT])
                @c.run 'right'
            if (@keysDown[Constant.KEYCODE_LEFT])
                @c.run 'left'
            if (@keysDown[Constant.KEYCODE_DOWN])
                @c.run 'down'
            if (@keysDown[Constant.KEYCODE_UP])
                @c.run 'up'
            if (@keysDown[Constant.KEYCODE_Z])
                @c.attack()
                if (@collide @enemy.getRect(), @c.getRect())
                    @enemy.gotHit()
                    @enemy.setState "hurt"

        ).bind this


        window.addEventListener "keydown", ((e) ->
            @keysDown[e.keyCode] = true
        ).bind this

        window.addEventListener "keyup", ((e) ->
            @keysDown[e.keyCode] = false
            if (!@keysDown[Constant.KEYCODE_RIGHT] && !@keysDown[Constant.KEYCODE_LEFT] && !@keysDown[Constant.KEYCODE_UP] && !@keysDown[Constant.KEYCODE_DOWN])
                if (@c.character.currentAnimation == "run")
                    @c.idle()
                @c.setState 'idle'
        ).bind this

    collide: (rect1, rect2) ->
        console.log 'rect1 ' + rect1.y2
        console.log 'rect2 ' + rect2.y2
        console.log (!(rect2.x2 < rect1.x1) && !(rect2.x1 > rect1.x2))
        console.log  (rect1.y2 - @Y_AXIS_THREASHOLD)
        console.log (rect1.y2 + @Y_AXIS_THREASHOLD)
        return (!(rect2.x2 < rect1.x1) && !(rect2.x1 > rect1.x2) && (rect2.y2 > (rect1.y2 - @Y_AXIS_THREASHOLD)) && (rect2.y2 < (rect1.y2 + @Y_AXIS_THREASHOLD)))


