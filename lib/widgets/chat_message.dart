import 'package:flutter/material.dart';

const String _name = "Bibek Timsina";

class ChatMessage extends StatelessWidget {
  final String text;
  final String sendBy;
  //for opotional params we use curly braces
  ChatMessage({this.text, this.sendBy});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: sendBy == 'notown'
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: Text(_name[0]),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Color(0xffC8C8C8),
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 16,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: Text(_name[0]),
                  ),
                ),
              ],
            ),
    );
  }
}
