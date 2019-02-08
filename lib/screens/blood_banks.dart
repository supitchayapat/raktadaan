import 'package:flutter/material.dart';
class BloodBanksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blood banks'),),
      body: Container(
        color: Color(0xFFC21807),
        child: Center(
          child: Text('Coming soon!',
          style: TextStyle(
            color: Colors.white, fontFamily: 'Open Sans', fontSize: 20,fontWeight: FontWeight.bold),),
        ),
      ),      
    );
  }
}