const express = require("express");
const socket = require("socket.io");

const PORT = 8080;
const app = express();

setupServer();

async function setupServer() {
  var response = await fetch("https://api.ipify.org?format=json");
  var data = await response.json();
  var IP = data.ip;

  
  const server = app.listen(PORT, IP);
  console.log("Listening on " + IP);

  const io = socket(server);

  io.on("connection", function (socket) {
    console.log("User connected");

    socket.on('drawings', function (data) {
      io.emit('drawings', `${data}`)
    });

    socket.on('delete', function (data) {
      io.emit('delete')
    });

    socket.on('allDrawings', function (data) {
      io.emit('allDrawings', `${data}`)
    });

    socket.on('connected', function (data) {
      io.emit('connected', `${data}`)
    });

    socket.on('disconnect', function () {
        console.log('User disconnected');
    });
  });
}

