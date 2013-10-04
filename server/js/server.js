// Generated by CoffeeScript 1.6.1
(function() {
  var Player, Server, gameServer, io, util;

  util = require("util");

  io = require("socket.io");

  Player = require("../../js/Player").Player;

  Server = (function() {

    function Server() {}

    Server.prototype.init = function() {
      this.socket = io.listen(8000);
      this.socket.configure((function() {
        this.socket.set("transports", ["websocket"]);
        return this.socket.set("log level", 2);
      }).bind(this));
      this.setEventHandlers();
      return util.log("Server init()");
    };

    Server.prototype.setEventHandlers = function() {
      return this.socket.sockets.on("connection", this.onSocketConnection);
    };

    Server.prototype.onSocketConnection = function(client) {
      return util.log("New Player has connected:");
    };

    return Server;

  })();

  gameServer = new Server;

  gameServer.init();

}).call(this);
