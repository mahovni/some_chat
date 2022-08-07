const express = require("express");
const { createServer } = require("http");
const { Server } = require("socket.io");

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer);

app.route("/").get((req, res) => {
    res.json("Hey")
})

io.on("connection", (socket) => {
    console.log("backend connected");
    socket.on("sendMsg", (msg) => {
        console.log("msg", msg);
        socket.emit("sendMsgServer",{...msg, type: "otherMsg"})
    })
});

httpServer.listen(3000);