// Generated by CoffeeScript 1.6.1
(function() {
  var Server, gameServer;

  Server = (function() {

    function Server() {
      this.util = require("util");
      this.io = require("socket.io");
      this.Character = require("./Character").Character;
      this.init();
    }

    Server.prototype.init = function() {
      this.socket = this.io.listen(8000);
      this.socket.configure(function() {
        this.set("transports", ["websocket"]);
        return this.set("log level", 2);
      });
      return this.setEventHandlers();
    };

    Server.prototype.setEventHandlers = function() {
      return this.socket.sockets.on("connection", this.onSocketConnection.bind(this));
    };

    Server.prototype.onSocketConnection = function(client) {
      this.util.log("New Player has connected:" + client.id);
      return client.on("new player", this.onNewPlayer.bind(this));
    };

    Server.prototype.onNewPlayer = function(data) {
      var newPlayer;
      this.util.log('New Player Location:' + data.x + "," + data.y);
      newPlayer = new this.Character(data.id, data.x, data.y);
      return this.socket.sockets.emit("new player", {
        id: data.id,
        x: data.x,
        y: data.y
      });
    };

    return Server;

  })();

  gameServer = new Server;

}).call(this);
