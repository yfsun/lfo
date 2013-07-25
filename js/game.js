(function() {

  window.Game = (function() {

    function Game() {
      this.Y_AXIS_THREASHOLD = 30;
    }

    Game.prototype.init = function() {
      var background, shape;
      this.rect = new createjs.Rectangle(0, 0, 100, 100);
      this.keysDown = {};
      this.players = [];
      this.stage = new createjs.Stage(document.getElementById("gameCanvas"));
      background = new createjs.Graphics().beginFill("#000000").drawRect(0, 0, this.stage.canvas.width, this.stage.canvas.height);
      shape = new createjs.Shape(background);
      shape.x = 0;
      shape.y = 0;
      this.stage.addChild(shape);
      this.c = new Character("firzen", "assets/spritesheets/firzen.png", 5, 250, 100);
      this.enemy = new Character('firzen', "assets/spritesheets/firzen.png", 5, 400, 100);
      this.c.addToStage(this.stage);
      this.enemy.addToStage(this.stage);
      this.players.push(this.c);
      this.players.push(this.enemy);
      this.hud = new Hud(this.players, this.stage.canvas.width, 100, this.stage);
      this.arena = new Arena(this.stage.canvas.width, this.stage.canvas.height - 100, this.players);
      this.arena.setPosition(0, 100);
      this.arena.addToStage(this.stage);
      createjs.Ticker.setFPS(60);
      createjs.Ticker.addEventListener("tick", this.stage);
      this.ready = false;
      this.lastKeyPress = new Date();
      console.log(stage);
      this.attackQueue = [];
      createjs.Ticker.addEventListener("tick", (function(evt) {
        if (this.keysDown[Constant.KEYCODE_RIGHT]) {
          this.c.run('right');
        }
        if (this.keysDown[Constant.KEYCODE_LEFT]) {
          this.c.run('left');
        }
        if (this.keysDown[Constant.KEYCODE_DOWN]) {
          this.c.run('down');
        }
        if (this.keysDown[Constant.KEYCODE_UP]) {
          this.c.run('up');
        }
        if (this.keysDown[Constant.KEYCODE_Z]) {
          this.c.attack();
          if (this.collide(this.enemy.getRect(), this.c.getRect())) {
            this.enemy.gotHit();
            return this.enemy.setState("hurt");
          }
        }
      }).bind(this));
      window.addEventListener("keydown", (function(e) {
        return this.keysDown[e.keyCode] = true;
      }).bind(this));
      return window.addEventListener("keyup", (function(e) {
        this.keysDown[e.keyCode] = false;
        if (!this.keysDown[Constant.KEYCODE_RIGHT] && !this.keysDown[Constant.KEYCODE_LEFT] && !this.keysDown[Constant.KEYCODE_UP] && !this.keysDown[Constant.KEYCODE_DOWN]) {
          if (this.c.character.currentAnimation === "run") {
            this.c.idle();
          }
          return this.c.setState('idle');
        }
      }).bind(this));
    };

    Game.prototype.collide = function(rect1, rect2) {
      console.log('rect1 ' + rect1.y2);
      console.log('rect2 ' + rect2.y2);
      console.log(!(rect2.x2 < rect1.x1) && !(rect2.x1 > rect1.x2));
      console.log(rect1.y2 - this.Y_AXIS_THREASHOLD);
      console.log(rect1.y2 + this.Y_AXIS_THREASHOLD);
      return !(rect2.x2 < rect1.x1) && !(rect2.x1 > rect1.x2) && (rect2.y2 > (rect1.y2 - this.Y_AXIS_THREASHOLD)) && (rect2.y2 < (rect1.y2 + this.Y_AXIS_THREASHOLD));
    };

    return Game;

  })();

}).call(this);

// Generated by CoffeeScript 1.5.0-pre
