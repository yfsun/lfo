// Generated by CoffeeScript 1.6.1
(function() {

  window.Character = (function() {

    function Character(name, image, speed, x, y, stage) {
      this.name = name;
      this.image = image;
      this.speed = speed;
      this.x = x;
      this.y = y;
      this.stage = stage;
      this.id;
      this.hp = 100;
      this.spriteSheetInfo;
      this.character;
      this.characterSpriteSheet;
      this.direction = "right";
      this.stage;
      this.state = "idle";
      this.init();
    }

    Character.prototype.init = function() {
      this.spriteSheetInfo = {
        animations: {
          idle: {
            frames: [0, 1, 2, 3, 2],
            frequency: 10
          },
          run: {
            frames: [20, 21, 22, 21],
            frequency: 10
          },
          attack: {
            frames: [10, 11, 12, 13, 14, 15, 16, 17],
            frequency: 10
          },
          hurt: {
            frames: [53, 54, 55],
            frequency: 10
          }
        },
        images: [this.image],
        frames: {
          height: 80,
          width: 80,
          regX: 40,
          regY: 40
        }
      };
      console.log('init');
      this.characterSpriteSheet = new createjs.SpriteSheet(this.spriteSheetInfo);
      this.character = new createjs.BitmapAnimation(this.characterSpriteSheet);
      this.character.x = this.x;
      this.character.y = this.y;
      this.character.gotoAndPlay("idle");
      return this.character.addEventListener("animationend", (function(evt) {
        if ((this.state === 'idle') || (this.state === 'hurt')) {
          return this.idle();
        }
      }).bind(this));
    };

    Character.prototype.addToStage = function(stage) {
      stage.addChild(this.character);
      return this.stage = stage;
    };

    Character.prototype.run = function(direction) {
      if (this.character.currentAnimation !== "run") {
        this.character.gotoAndPlay("run");
      }
      this.state = "run";
      switch (direction) {
        case "left":
          if (this.direction !== "left") {
            this.changeDirection("left");
          }
          this.character.x -= this.speed;
          break;
        case "right":
          if (this.direction !== "right") {
            this.changeDirection("right");
          }
          this.character.x += this.speed;
          break;
        case "down":
          this.character.y += this.speed;
          break;
        case "up":
          this.character.y -= this.speed;
      }
      this.character.localToGlobal(this.x, this.y);
      this.x = this.character.x;
      return this.y = this.character.y;
    };

    Character.prototype.attack = function() {
      if (this.character.currentAnimation === "idle") {
        return this.character.gotoAndPlay("attack");
      }
    };

    Character.prototype.getRect = function() {
      var x1, x2, y1, y2;
      x1 = this.character.getBounds().x + this.character.x;
      y1 = this.character.getBounds().y + this.character.y;
      x2 = this.character.getBounds().x + this.character.x + this.character.getBounds().width;
      y2 = this.character.getBounds().y + this.character.y + this.character.getBounds().height;
      return {
        "x1": x1,
        "x2": x2,
        "y1": y1,
        "y2": y2
      };
    };

    Character.prototype.changeDirection = function(direction) {
      this.direction = direction;
      return this.character.scaleX = -this.character.scaleX;
    };

    Character.prototype.idle = function() {
      this.setState('idle');
      if (this.character.currentAnimation !== "idle") {
        return this.character.gotoAndPlay("idle");
      }
    };

    Character.prototype.gotHit = function() {
      if (this.state === 'idle') {
        this.setState('hurt');
        this.character.gotoAndPlay("hurt");
        return this.character.x -= this.speed;
      }
    };

    Character.prototype.setState = function(state) {
      return this.state = state;
    };

    Character.prototype.getPlayer = function() {
      return this.character;
    };

    return Character;

  })();

}).call(this);
