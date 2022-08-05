import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final String name;
  const ChatPage({Key? key, required this.name}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  IO.Socket? socket;
  @override
  void initState() {
    super.initState();
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
                Expanded(child: Container()),
              ],
            )),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 15),
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Type something...",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
                ),
              )),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send),
                color: Color.fromARGB(255, 5, 89, 157),
              )
            ],
          ),
        ),
      ),
    );
  }
}
