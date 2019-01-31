import 'package:flutter/material.dart';
import 'package:raktadaan/modal_class/chat_modal.dart';
import 'package:raktadaan/screens/single_message.dart';


class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {


  Widget messages(){
        return new ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (context, i) => new Column(
            children: <Widget>[
              new Divider(
                height: 10.0,
              ),
              new ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context)=> ChatScreen()
                  ));
                },
                leading: new CircleAvatar(
                  foregroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  backgroundImage: new NetworkImage(dummyData[i].avatarUrl),
                ),
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      dummyData[i].name,
                      style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),
                    ),
                    new Text(
                      dummyData[i].time,
                      style: new TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
                subtitle: new Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    dummyData[i].message,
                    style: new TextStyle(color: Colors.white54, fontSize: 15.0),
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
      body: Container(color: Colors.blue,
      child: messages(),),
    );
  }
}
