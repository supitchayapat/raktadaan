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
      date: '2 April 2018',
      description: 'Blood Donation event organized by Red Cross Society.',
      place: 'Pulchowk',
      time: '3:20 PM',
    ),
    Event(
      date: '1 April 2018',
      description: 'Awareness campaign event organized by Nepal Scout Society.',
      place: 'Maharajgunj',
      time: '8:10 AM',
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
