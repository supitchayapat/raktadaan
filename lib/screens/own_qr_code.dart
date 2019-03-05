import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:raktadaan/screens/scan_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnQR extends StatefulWidget {
  @override
  OwnQRState createState() {
    return new OwnQRState();
  }
}

class OwnQRState extends State<OwnQR> {
  SharedPreferences preferences;
  bool isLoggedIn;
  int userId;

  _prepareSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      userId = preferences.getInt('userId');
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _prepareSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your QR'),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  color: Colors.white,
                  child: QrImage(
                    data: userId.toString(),
                    size: 200.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(50)),
                child: FlatButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.closed_caption,
                        color: Colors.white,
                      ),
                      Text(
                        'Scan QR Code',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    //Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ScanQr()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
