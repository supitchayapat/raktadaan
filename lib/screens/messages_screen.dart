import 'package:flutter/material.dart';
import 'package:raktadaan/modal_class/chat_modal.dart';
import 'package:raktadaan/screens/single_message.dart';
import 'package:web_socket_channel/io.dart';


class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Widget messages() {
    return  ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (context, i) =>  Column(
            children: <Widget>[
               ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatScreen(
                        channel: IOWebSocketChannel.connect(
                          'ws://192.168.137.46:8080/foo'),
                          sendId: '2',
                      )));
                },
                leading:  CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  backgroundImage:  AssetImage('assets/images/face1.jpeg'),
                ),
                title:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                     Text(
                      dummyData[i].name,
                      style:  TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                     Text(
                      dummyData[i].time,
                      style:
                           TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
                subtitle:  Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child:  Text(
                    dummyData[i].message,
                    style:  TextStyle(color: Colors.white54, fontSize: 15.0),
                  ),
                ),
              )
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Container(
        color: Color(0xFFC21807),
        child: messages(),
      ),
    );
  }
}
