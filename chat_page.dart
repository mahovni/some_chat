import 'package:experiment/other_msg_widget.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'msg_model.dart';
import 'own_msg_widget.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String userId;
  const ChatPage({Key? key, required this.name, required this.userId})
      : super(key: key);

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  IO.Socket? socket;
  List<MsgModel> listMsg = [];
  final TextEditingController _msgController = TextEditingController();
  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    socket = IO.io("http://localhost:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.onConnect((_) => {
          socket!.on("sendMsgServer", (msg) {
            if (msg["userId"] != widget.userId) {
              setState(() {
                listMsg.add(
                  MsgModel(
                      msg: msg["msg"],
                      type: msg["type"],
                      sender: msg["senderName"]),
                );
              });
            }
          })
        });
  }

  void sendMsg(String msg, senderName) {
    MsgModel ownMsg = MsgModel(msg: msg, type: "ownMsg", sender: senderName);

    setState(() {
      listMsg.add(ownMsg);
    });
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "senderName": senderName,
      "userId": widget.userId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Some chat')),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF1976D2), Color(0xFF42A5F5)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
        ),
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Color.fromARGB(255, 17, 212, 105),
                  Color.fromARGB(255, 125, 189, 242),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: listMsg.length,
                        itemBuilder: (context, index) {
                          if (listMsg[index].type == "ownMsg") {
                            return ownMsgWidget(
                                msg: listMsg[index].msg,
                                sender: listMsg[index].sender);
                          } else {
                            return otherMsgWidget(
                                msg: listMsg[index].msg,
                                sender: listMsg[index].sender);
                          }
                        })),
              ],
            )),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 15),
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: _msgController,
                decoration: const InputDecoration(
                  hintText: "Type something...",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
                ),
              )),
              IconButton(
                onPressed: () {
                  String msg = _msgController.text;
                  if (msg.isNotEmpty) {
                    sendMsg(msg, widget.name);
                    _msgController.clear();
                  }
                },
                icon: const Icon(Icons.send),
                color: const Color.fromARGB(255, 5, 89, 157),
              )
            ],
          ),
        ),
      ),
    );
  }
}
