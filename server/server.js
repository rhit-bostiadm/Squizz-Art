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
    io.emit('connected');

    socket.on('currentDrawing', function (data) {
      io.emit('currentDrawing', `${data}`)
    });

    socket.on('drawings', function (data) {
      io.emit('drawings', `${data}`)
    });

    socket.on('delete', function (data) {
      io.emit('delete')
    });

    socket.on('allDrawings', function (data) {
      io.emit('allDrawings', `${data}`)
    });

    socket.on('allCurrentDrawings', function (data) {
      io.emit('allCurrentDrawings', `${data}`)
    });

    socket.on('disconnect', function () {
        console.log('User disconnected');
    });
  });
}

