import 'package:flutter/material.dart';
import 'package:raktadaan/modal_class/event.dart';
import 'package:raktadaan/widgets/single_event.dart';

class Eventspage extends StatefulWidget {
  @override
  EventspageState createState() {
    return new EventspageState();
  }
}

class EventspageState extends State<Eventspage> {
  List<Event> events = [
    Event(
      date: '३० फाल्गुन २०७५',
      description: 'रेड क्रस सोसाइटी द्वारा आयोजित रक्तदान कार्यक्रम |',
      place: 'पाटन',
      time: '१२ : ०० PM',
    ),
    Event(
      date: '२९  फाल्गुन २०७५',
      description: 'नेपाल स्काउट सोसाइटीले युवा जन चेतना कार्यक्रम आयोजना गर्दै ।',
      place: 'बुटवल',
      time: '३ : ००  AM',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: rideList(context, events),
      ),
    );
  }

  Widget rideList(BuildContext context, List<Event> rides) {
    return ListView.builder(
      itemCount: rides.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return SingleEvent(
          event: rides[index],
        );
      },
    );
  }
}
