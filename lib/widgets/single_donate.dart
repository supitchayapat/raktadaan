import 'package:flutter/material.dart';

import 'package:raktadaan/modal_class/donate.dart';

class SingleDonate extends StatefulWidget {
  final Donate donate;
  SingleDonate({this.donate});
  @override
  _SingleDonateState createState() => _SingleDonateState();
}

class _SingleDonateState extends State<SingleDonate> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: donateBody(context),
      ),
    );
  }

  Widget donateBody(BuildContext context) {
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
                    widget.donate.place,
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
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  child: Text(widget.donate.bloodType),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.donate.description,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontFamily: 'Open Sans'),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.phone),
                onPressed: () {},
              )
            ],
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
                      widget.donate.time,
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
                Text(
                  widget.donate.date,
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
