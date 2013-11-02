class window.Character
    constructor: (@name, @image, @speed, @x, @y, @stage) ->
        @id
        @hp = 100
        @spriteSheetInfo
        @character
        @characterSpriteSheet
        @direction = "right"
        @stage
        @state = "idle"
        @init()



    init:() ->
        @spriteSheetInfo =
          animations:
            idle:
              frames: [0, 1, 2, 3, 2]
              frequency: 10

            run:
              frames: [20, 21, 22, 21]
              frequency: 10

            attack:
              frames: [10, 11, 12, 13,14,15,16,17]
              frequency: 10

            hurt:
              frames: [53, 54, 55]
              frequency: 10

          images: [@image]

          frames:
            height: 80
            width: 80
            regX: 40
            regY: 40

        console.log 'init'
        @characterSpriteSheet = new createjs.SpriteSheet @spriteSheetInfo
        @character = new createjs.BitmapAnimation @characterSpriteSheet
        @character.x = @x
        @character.y = @y
        @character.gotoAndPlay "idle"

        @character.addEventListener "animationend", ((evt) ->
            if ((@state == 'idle') || (@state == 'hurt'))
                @idle()

        ).bind this


    addToStage: (stage) ->
        stage.addChild(@character)
        @stage = stage


    run: (direction) ->
        if (@character.currentAnimation != "run")
            @character.gotoAndPlay "run"
        @state = "run"
        switch direction
            when "left"
                if (@direction != "left")
                    @changeDirection "left"
                @character.x -= @speed
            when "right"
                if (@direction != "right")
                    @changeDirection "right"
                @character.x += @speed
            when "down"
                @character.y += @speed
            when "up"
                @character.y -= @speed
        @character.localToGlobal @x, @y
        @x = @character.x
        @y = @character.y
    attack: ->
        if @character.currentAnimation == "idle"
            @character.gotoAndPlay "attack"

    getRect: ->
        x1 = @character.getBounds().x + @character.x
        y1 = @character.getBounds().y + @character.y
        x2 = @character.getBounds().x + @character.x + @character.getBounds().width
        y2 = @character.getBounds().y + @character.y + @character.getBounds().height
        return {"x1":x1, "x2":x2, "y1":y1, "y2":y2}

    changeDirection: (direction) ->
            @direction = direction
            @character.scaleX = -@character.scaleX

    idle: ->
        @setState 'idle'
        if (@character.currentAnimation != "idle")
            @character.gotoAndPlay "idle"

    gotHit: () ->
        if (@state == 'idle')
            @setState 'hurt'
            @character.gotoAndPlay "hurt"
            @character.x -=@speed

    setState: (state) ->
        @state = state

    getPlayer: ->
        return @character


