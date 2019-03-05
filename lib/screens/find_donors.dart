import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:raktadaan/modal_class/donor.dart';
import 'package:http/http.dart' as http;
import 'package:raktadaan/screens/single_message.dart';
import 'package:web_socket_channel/io.dart';

class FindDonorsPage extends StatefulWidget {
  final String userId, bloodGrp, gender;
  FindDonorsPage({this.userId, this.bloodGrp, this.gender});
  @override
  State<StatefulWidget> createState() {
    return FindDonorsPageState();
  }
}

class FindDonorsPageState extends State<FindDonorsPage> {
  final findDonorsPageScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  bool mapToggle = false;
  List<Donor> list = List();
  bool isLoading = true;
  bool noDonors = false;
  var currentLocation;
  List<LatLng> markers = List();
  void _upload() {
    http.post('http://192.168.137.169:3000/search_donor', body: {
      "userid": widget.userId,
      "long": currentLocation.longitude.toString(),
      "lat": currentLocation.latitude.toString(),
      "blood_grp": widget.bloodGrp,
      "gender": widget.gender
    }).then((res) {
      print(res.statusCode);
      list = (json.decode(res.body) as List)
          .map((data) => Donor.fromJson(data))
          .toList();
      if (this.mounted) {
        if (list.length == 0) {
          setState(() {
            noDonors = true;
          });
        } else {
          setState(() {
            mapToggle = true;
            print(list.length);
          });
        }
      }
    }).catchError((err) {
      print('ma call bhaye');
      print(err);
      setState(() {
        isLoading = false;
        noDonors = true;
      });
    });
  }

  // _fetchData() async {
  //   final response = await http.get(
  //       "http://192.168.137.169:3000/search_donor?long=85.335270&lat=27.688203");
  //   if (response.statusCode == 200) {
  //     list = (json.decode(response.body) as List)
  //         .map((data) => Donor.fromJson(data))
  //         .toList();
  //     if (this.mounted) {
  //       if (list.length == 0) {
  //         setState(() {
  //           noDonors = true;
  //         });
  //       } else {
  //         setState(() {
  //           mapToggle = true;
  //           print(list.length);
  //         });
  //       }
  //     }
  //   } else {
  //     throw Exception('Failed to load photos');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Geolocator().getLastKnownPosition().then((curloc) {
      currentLocation = curloc;
      //_fetchData();
      _upload();
      //_showBottomSheet();
    });
  }

  @override
  void dispose() {
    mapController?.onMarkerTapped?.remove(_onMarkerTapped);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: findDonorsPageScaffoldKey,
      appBar: myAppBar(),
      body: myBody(),
    );
  }

  //All the widget definitions
  Widget myAppBar() {
    return AppBar(
      title: Text("Find Donors"),
    );
  }

  //This is body
  Widget myBody() {
    return Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        height: double.infinity,
        child: noDonors
            ? noDonorsFound()
            : mapToggle
                ? GoogleMap(
                    onMapCreated: _onMapCreated,
                    options: GoogleMapOptions(
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      trackCameraPosition: true,
                      cameraPosition: CameraPosition(
                        target: currentLocation == null
                            ? LatLng(27.7172, 85.3240)
                            : LatLng(currentLocation.latitude,
                                currentLocation.longitude),
                        zoom: 12.0,
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ));
  }

  Widget noDonorsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 100,
            height: 100,
            child: Icon(
              FontAwesomeIcons.sadTear,
              color: Colors.white,
              size: 80,
            ),
          ),
          Text(
            "Sorry no donors found.",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.bold),
          ),
          RaisedButton(
            color: Colors.purple,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
              child: Text(
                'RETRY',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              setState(() {
                noDonors = false;
                isLoading = true;
              });
              //_fetchData();
              _upload();
            },
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    mapController.onMarkerTapped.add(_onMarkerTapped);
    _addMarkers();
  }

  _addMarkers() async {
    for (int i = 0; i < list.length; i++) {
      markers.add(LatLng(list[i].latitude, list[i].longitude));
      mapController.addMarker(MarkerOptions(
        position: LatLng(list[i].latitude, list[i].longitude),
      ));
    }
  }

  void _onMarkerTapped(Marker marker) {
    LatLng clicked = LatLng(
        marker.options.position.latitude, marker.options.position.longitude);
    int clickedIndex;
    for (int i = 0; i < markers.length; i++) {
      if (clicked == markers[i]) {
        clickedIndex = i;
        break;
      }
    }
    showPicker(clickedIndex);
  }

  showPicker(int selectedIndex) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            //title: Center(child: Text('Donor Derails')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Donor Details',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Respect : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      '${list[selectedIndex].credits}',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Gender : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      '${list[selectedIndex].gender}',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Blood Group : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      '${list[selectedIndex].bloodGrp}',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      channel: IOWebSocketChannel.connect(
                                          'ws://192.168.137.46:8080/foo'),
                                      sendId: list[selectedIndex].id.toString(),
                                    )));
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
