class window.Arena
	constructor: (@w, @h, @players = {}) ->

		# Root container for battle arena
		@container = new createjs.Container();
		@container.x = 0;
		@container.y = 0;

		# Background for arena
		background = new createjs.Graphics().beginFill("#FFFFFE").drawRect 0, 0, @w, @h
		shape = new createjs.Shape background
		shape.x = 0
		shape.y = 0
		@container.addChild shape
		@init()

	init: ->
		for p in @players
			console.log 'add'
			@container.addChild p.getPlayer()

	setPosition: (x, y) ->
		@container.x = x
		@container.y = y

	addPlayer: (player) ->
		@container.addChild player.getPlayer()
		@players.push player

	addToStage: (stage) ->
		stage.addChild @container

	getPlayers: ->
		return @players