import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:raktadaan/modal_class/blood_bank.dart';

class BloodBanksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BloodBanksPageState();
  }
}

class BloodBanksPageState extends State<BloodBanksPage> {
  final bloodBanksPageScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  bool mapToggle = false;
  List<BloodBank> list = List();
  bool isLoading = true;
  bool noAmbulances = false;
  var currentLocation;
  List<LatLng> markers = List();
  var places = ['Arghakhachi', 'Gulmi', 'Illam'];
  String selectedPlace = 'Gulmi';
  LatLng argLoc = LatLng(27.944839, 83.092367);
  LatLng gulLoc = LatLng(28.089279, 83.275836);
  LatLng ilLoc = LatLng(26.900164, 87.926750);
  var bloodGroups = ['O−', 'O+', 'A−', 'A+', 'B−', 'B+', 'AB−', 'AB+'];

  _fetchData() async {
    list = [
      BloodBank(
          name: 'Red Cross',
          phone: '1234567890',
          latitude: 27.684996,
          longitude: 85.325653),
      BloodBank(
          name: 'Red Cross',
          phone: '1234567890',
          latitude: 27.67490,
          longitude: 85.32560),
      BloodBank(
          name: 'Red Cross',
          phone: '1234567890',
          latitude: 27.664596,
          longitude: 85.325623)
    ];
    setState(() {
      mapToggle = true;
    });
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
      key: bloodBanksPageScaffoldKey,
      appBar: myAppBar(),
      body: myBody(),
    );
  }

  //All the widget definitions
  Widget myAppBar() {
    return AppBar(
      title: Text("Blood Banks"),
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
                      myLocationEnabled: true,
                      cameraPosition: CameraPosition(
                        target: LatLng(27.681494, 85.323875),
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
                  target: selectedPlace == 'Arghakhachi'
                      ? argLoc
                      : selectedPlace == 'Illam' ? ilLoc : gulLoc,
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
            "Sorry no blood banks found.",
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Blood Bank Details',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Name : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      '${list[selectedIndex].name}',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      '${list[selectedIndex].phone}',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () {
                        Navigator.pop(context);
                        //launch("tel://9862166357");
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 1.5),
                      itemCount: bloodGroups.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 3),
                              borderRadius: BorderRadius.circular(4.0)),
                          width: 10,
                          height: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(bloodGroups[index]),
                              Icon(Icons.check)
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        });
  }
}
