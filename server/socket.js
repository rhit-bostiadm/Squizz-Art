const express = require("express");
const socket = require("socket.io");

const PORT = 8080;
const app = express();


const server = app.listen(PORT, "137.112.216.124");

const io = socket(server);

io.on("connection", function (socket) {
  console.log("Made socket connection");

  socket.on('currentDrawing', function (data) {
    io.emit('currentDrawing', `${data}`)
  });

  socket.on('drawings', function (data) {
    io.emit('drawings', `${data}`)
  });

  socket.on('disconnect', function () {
      console.log('A user disconnected');
  });
});