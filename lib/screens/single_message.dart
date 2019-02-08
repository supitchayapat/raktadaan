import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:raktadaan/widgets/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final WebSocketChannel channel;
  final String sendId;

  ChatScreen({this.channel, this.sendId});
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  String userId;
  SharedPreferences preferences;
  Map<String, dynamic> prevUser;

  void _sendMessage(String message) {
    //widget.channel.sink.add(message);
    String sendId = widget.sendId;
    widget.channel.sink.add(json.encode({
      'msg': "$message",
      'sendId': sendId,
      'userId': userId,
    }));
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  void _handleSubmit(String text) {
    textEditingController.clear();
    ChatMessage chatMessage = ChatMessage(text: text);
    setState(() {
      _messages.insert(0, chatMessage);
    });
  }

  _prepareSharedPrefs() async {
    preferences = await SharedPreferences.getInstance();
    userId = preferences.getInt('userId').toString();
    //_sendMessage('test');
  }

  Widget _textComposerWidget() {
    return IconTheme(
      data: IconThemeData(color: Color(0xFFC21807)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                decoration:
                    InputDecoration.collapsed(hintText: "Enter your message"),
                controller: textEditingController,
                onSubmitted: _handleSubmit,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  try {
                    _sendMessage(textEditingController.text);
                    textEditingController.clear();
                  } on Exception {
                    print('Exception');
                  }
                  //_handleSubmit(textEditingController.text);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _prepareSharedPrefs(); // widget.channel.stream.listen((data) {
    //   print("DataReceived: " + data);
    // }, onDone: () {
    //   print("Task Done");
    // }, onError: (error) {
    //   print("Some Error");
    // });
    // _listen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person Name'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> user = jsonDecode(snapshot.data);
                    if (prevUser == null) {
                      prevUser = user;
                      String msg = user['msg'];
                      String sendBy = user['send'];
                      print('$msg');
                      ChatMessage chatMessage = ChatMessage(
                        text: msg,
                        sendBy: sendBy,
                      );
                      _messages.insert(0, chatMessage);
                    } else {
                      if (prevUser != user) {
                        prevUser = user;
                        String msg = user['msg'];
                        String sendBy = user['send'];
                        print('$msg');
                        ChatMessage chatMessage = ChatMessage(
                          text: msg,
                          sendBy: sendBy,
                        );
                        _messages.insert(0, chatMessage);
                      }
                    }
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  );
                },
              ),
            ),
            // Expanded(child: StreamBuilder(
            //   stream: widget.channel.stream,
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     return Text(snapshot.hasData ? snapshot.data : 'waiting');
            //   },
            // )),
            // Flexible(
            //   child: ListView.builder(
            //     padding: EdgeInsets.all(8.0),
            //     reverse: true,
            //     itemBuilder: (_, int index) => _messages[index],
            //     itemCount: _messages.length,
            //   ),
            // ),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _textComposerWidget(),
            )
          ],
        ),
      ),
    );
  }
}
