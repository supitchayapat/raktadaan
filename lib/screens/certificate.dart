import 'package:flutter/material.dart';

class Certificate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text(
              'SHARE',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Hero(
        tag: 'certificate',
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xffC00000),
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/images/certificate.png'))),
        ),
      ),
    );
  }
}
