import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:raktadaan/modal_class/ambulance.dart';
import 'package:http/http.dart' as http;
import 'package:raktadaan/screens/single_message.dart';
import 'package:web_socket_channel/io.dart';

class AmbulancesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AmbulancesPageState();
  }
}

class AmbulancesPageState extends State<AmbulancesPage> {
  final ambulancesPageScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  bool mapToggle = false;
  List<Ambulance> list = List();
  bool isLoading = true;
  bool noAmbulances = false;
  var currentLocation;
  List<LatLng> markers = List();
  var places = ['Arghakhachi', 'Gulmi', 'Illam'];
  String selectedPlace = 'Gulmi';
  LatLng argLoc = LatLng(27.944839, 83.092367);
  LatLng gulLoc = LatLng(28.089279, 83.275836);
  LatLng ilLoc = LatLng(26.900164, 87.926750);

  _fetchData() async {
    final response = await http
        .get("http://192.168.137.169:3000/getambulance");
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => Ambulance.fromJson(data))
          .toList();
      if (this.mounted) {
        if (list.length == 0) {
          setState(() {
            noAmbulances = true;
          });
        } else {
          setState(() {
            mapToggle = true;
            print(list.length);
          });
        }
      }
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  void initState() {
    super.initState();
    // Geolocator().getLastKnownPosition().then((curloc) {
    //   currentLocation = curloc;
      
    // });
    _fetchData();
  }

  @override
  void dispose() {
    mapController?.onMarkerTapped?.remove(_onMarkerTapped);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ambulancesPageScaffoldKey,
      appBar: myAppBar(),
      body: myBody(),
    );
  }

  //All the widget definitions
  Widget myAppBar() {
    return AppBar(
      title: Text("Ambulances"),
      actions: <Widget>[
        bloodDropDown()
      ],
    );
  }

  //This is body
  Widget myBody() {
    return Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        height: double.infinity,
        child: noAmbulances
            ? noAmbulancesFound()
            : mapToggle
                ? GoogleMap(
                    onMapCreated: _onMapCreated,
                    options: GoogleMapOptions(
                      mapType: MapType.normal,
                      trackCameraPosition: true,
                      cameraPosition: CameraPosition(
                        target: selectedPlace == 'Arghakhachi'
                            ? argLoc
                            : selectedPlace == 'Illam'?
                            ilLoc:
                                gulLoc,
                        zoom: 13.0,
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ));
  }
    Widget bloodDropDown() {
    return Theme(
      data: ThemeData(
        canvasColor: Theme.of(context).primaryColor,
      ),
      child: DropdownButton<String>(
        hint: Text('Select your blood type'),
        style: TextStyle(
            color: Colors.white, fontFamily: 'Open Sans', fontSize: 16),
        items: places.map((String dropDownStringItem) {
          return DropdownMenuItem(
            value: dropDownStringItem,
            child: Container(
                child: Text(
              dropDownStringItem,
              style: TextStyle(fontFamily: 'Open Sans'),
            )),
          );
        }).toList(),
        onChanged: (String selectedBlood) {
          setState(() {
            selectedPlace = selectedBlood;
          });
          mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target:  selectedPlace == 'Arghakhachi'
                            ? argLoc
                            : selectedPlace == 'Illam'?
                            ilLoc:
                                gulLoc,
                       zoom: 13.0),
                ),
              );
        },
        value: selectedPlace,
      ),
    );
  }

  Widget noAmbulancesFound() {
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
            "Sorry no Ambulances found.",
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
                noAmbulances = false;
                isLoading = true;
              });
              _fetchData();
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
            
            //title: Center(child: Text('Ambulance Derails')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Ambulance Details',
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
                      'Number : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      '${list[selectedIndex].number}',
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
                      'Available : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      '${list[selectedIndex].online}',
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
                      'Distance : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        '${list[selectedIndex].name}',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
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
                        //launch("tel://9862166357");
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
