import 'package:flutter/material.dart';
import 'package:raktadaan/modal_class/donate.dart';
import 'package:raktadaan/widgets/single_donate.dart';

class DonatePage extends StatefulWidget {
  @override
  DonatePageState createState() {
    return new DonatePageState();
  }
}

class DonatePageState extends State<DonatePage> {
  List<Donate> events = [
    Donate(
      date: 'फाल्गुन २१',
      description: 'अल्का अस्पतालमा नवजात शिशुलाई रगत चाहिएको |',
      place: 'जावलाखेल',
      time: '३:२० PM',
      bloodType: 'A+'
    ),
    Donate(
      date: 'फाल्गुन २१',
      description: 'क्यान्सरको उपचार को लागि |',
      place: 'पुल्चोक',
      time: '८:१०  AM',
      bloodType: 'B+'
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate'),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: rideList(context, events),
      ),
    );
  }

  Widget rideList(BuildContext context, List<Donate> rides) {
    return ListView.builder(
      itemCount: rides.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return SingleDonate(
          donate: rides[index],
        );
      },
    );
  }
}
