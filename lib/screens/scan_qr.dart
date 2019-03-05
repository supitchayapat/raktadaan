import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class ScanQr extends StatefulWidget {
  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  bool camState = false;

  @override
  initState() {
    super.initState();
  }

  Widget scanner() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: QrCamera(
        onError: (context, error) => Text(
              error.toString(),
              style: TextStyle(color: Colors.white),
            ),
        qrCodeCallback: (code) {
          print(code);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Stack(
        children: <Widget>[
          scanner(),
          Column(
            children: <Widget>[
              AppBar(
                title: Text('QRScan'),
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Place the QR code inside the square. It will be scnned automatically.',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(8))),
              ),
              Expanded(
                child: Center(
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
                            'My QR Code',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => OwnQR()));
                      },
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
