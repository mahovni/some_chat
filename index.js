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
    socket.join("some_chat");
    console.log("backend connected");
    socket.on("sendMsg", (msg) => {
        console.log("msg", msg);
        io.to("some_group").emit("sendMsgServer", { ...msg, type: "otherMsg" });

    })
});

httpServer.listen(3000);
