import 'package:flutter/material.dart';

import 'package:raktadaan/modal_class/event.dart';

class SingleEvent extends StatefulWidget {
  final Event event;
  SingleEvent({this.event});
  @override
  _SingleEventState createState() => _SingleEventState();
}

class _SingleEventState extends State<SingleEvent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: eventBody(context),
      ),
    );
  }

  Widget eventBody(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.my_location,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.event.place,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open Sans'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              child: Text(
                widget.event.description,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontFamily: 'Open Sans'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.timer,
                      color: Colors.black45,
                      size: 15,
                    ),
                    Text(
                      widget.event.time,
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
                Text(
                  widget.event.date,
                  style: TextStyle(color: Colors.black45),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
