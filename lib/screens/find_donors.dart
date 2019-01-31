// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:math' as math;

// import 'package:raktadaan/modal_class/place.dart';

// class FindDonors extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return FindDonorsState();
//   }
// }

// class FindDonorsState extends State<FindDonors> with SingleTickerProviderStateMixin {
//   static List<String> nearbyPlaces = ["Baneshwor", "Maitighar", "Tripureshwor"];
//   static List<String> nearbytraffic = ["Heavy", "Light", "Moderate"];
//   static List<LatLng> nearbyCoordinates = [
//     LatLng(27.678647, 85.349561),
//     LatLng(27.694509, 85.320450),
//     LatLng(27.693781, 85.314122)
//   ];

//   List<Place> places = [
//     Place(
//         nearbyPlaces[0],
//         nearbytraffic[0],
//        nearbyCoordinates[0]),
//     Place(
//         nearbyPlaces[1],
//         nearbytraffic[1],
//         nearbyCoordinates[1]),
//     Place(
//         nearbyPlaces[2],
//         nearbytraffic[2],
//         nearbyCoordinates[2]),
//   ];

//   final findDonorsScaffoldKey = GlobalKey<ScaffoldState>();
//   GoogleMapController mapController;
//   PersistentBottomSheetController persistentBottomSheetController;
//   bool mapToggle = false;
//   bool isBottomSheetVisible = false;
//   var currentLocation;

//   AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     Geolocator().getLastKnownPosition().then((curloc) {
//       setState(() {
//         currentLocation = curloc;
//         mapToggle = true;
//       });
//       //_showBottomSheet();
//     });
//     _animationController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _animationController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: findDonorsScaffoldKey,
//       appBar: myAppBar(),
//       body: myBody(),
//       floatingActionButton: myFAB(),
//     );
//   }

//   void _refreshCurrentLocation() {
//     setState(() {
//       mapToggle = false;
//     });
//     Geolocator().getCurrentPosition().then((curLoc) {
//       setState(() {
//         currentLocation = curLoc;
//         mapToggle = true;
//       });
//     });
//   }

//   //All the widget definitions
//   Widget myAppBar() {
//     return AppBar(
//       backgroundColor: Colors.purple,
//       centerTitle: true,
//       title: Text("Smart Traffic"),
//       actions: <Widget>[
//         IconButton(
//           icon: Icon(Icons.refresh),
//           onPressed: _refreshCurrentLocation,
//         ),
//         IconButton(
//           icon: Icon(Icons.search),
//           onPressed: () async {
//             final Place result = await showSearch(
//                 context: context, delegate: PlacesSearch(places: places));
//             if (result != null) {
//               mapController.clearMarkers();
//               mapController.animateCamera(
//                 CameraUpdate.newCameraPosition(
//                   CameraPosition(
//                       target: result.nearbyCoordinates, zoom: 17.0),
//                 ),
//               );
//               mapController.addMarker(MarkerOptions(
//                 position: result.nearbyCoordinates,
//                 infoWindowText: InfoWindowText(
//                     result.nearbyPlaces, result.nearbyTraffic),
//                 icon: result.nearbyTraffic == 'Heavy'
//                     ? BitmapDescriptor.defaultMarkerWithHue(
//                         BitmapDescriptor.hueRed)
//                     : result.nearbyTraffic == 'Light'
//                         ? BitmapDescriptor.defaultMarkerWithHue(
//                             BitmapDescriptor.hueGreen)
//                         : BitmapDescriptor.defaultMarkerWithHue(
//                             BitmapDescriptor.hueYellow),
//               ));
//             }
//           },
//         )
//       ],
//     );
//   }

//   //This is body
//   Widget myBody() {
//     return Container(
//         width: double.infinity,
//         height: double.infinity,
//         child: mapToggle
//             ? GoogleMap(
//                 onMapCreated: _onMapCreated,
//                 options: GoogleMapOptions(
//                   mapType: MapType.normal,
//                   myLocationEnabled: true,
//                   trackCameraPosition: true,
//                   cameraPosition: CameraPosition(
//                     target: currentLocation == null
//                         ? LatLng(27.7172, 85.3240)
//                         : LatLng(currentLocation.latitude,
//                             currentLocation.longitude),
//                     zoom: 10.0,
//                   ),
//                 ),
//               )
//             : Center(
//                 child: CircularProgressIndicator(),
//               ));
//   }



//   Widget myFAB() {
//     return FloatingActionButton.extended(
//       backgroundColor: Colors.purple,
//       // icon: isBottomSheetVisible
//       //     ? Icon(Icons.arrow_downward)
//       //     : Icon(Icons.arrow_upward),
//       icon: AnimatedBuilder(
//         child: Icon(Icons.arrow_upward),
//         animation: _animationController,
//         builder: (context, child) => Transform.rotate(
//               child: child,
//               angle: _animationController.value * 2.0 * math.pi / 2,
//             ),
//       ),
//       onPressed: handleBottomSheet,
//       label: Text(
//         'Nearby',
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget myBottomSheet() {
//     return Container(
//       height: 230.0,
//       decoration: BoxDecoration(
//         color: Colors.deepPurple,
//         borderRadius: new BorderRadius.only(
//           topLeft: new Radius.circular(15.0),
//           topRight: new Radius.circular(15.0),
//           //bottomRight: new Radius.circular(20.0),
//           //bottomLeft: new Radius.circular(20.0),
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
//                 child: Container(
//                   height: 2.0,
//                   width: 30.0,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 child: getListView(),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget getListView() {
//     var listview = ListView.builder(
//       itemCount: places.length == null ? 0 : places.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           leading: Icon(
//             Icons.directions_bus,
//             color: Colors.white,
//           ),
//           trailing: IconButton(
//             icon: Icon(
//               Icons.arrow_forward_ios,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               // Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //       builder: (context) => PlaceDetail(
//               //             channel: IOWebSocketChannel.connect(
//               //                 'ws://192.168.137.1:8080/'),
//               //             title: places[index].nearbyPlaces,
//               //           ),
//               //     ));
//             },
//           ),
//           title: Text(
//             places[index].nearbyPlaces,
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18.0,
//                 color: Colors.white),
//           ),
//           subtitle: Text(
//             places[index].nearbyTraffic,
//             style: TextStyle(fontSize: 14.0, color: Colors.grey),
//           ),
//           onTap: () {
//             mapController.clearMarkers();
//             mapController.animateCamera(
//               CameraUpdate.newCameraPosition(
//                 CameraPosition(
//                     target: places[index].nearbyCoordinates, zoom: 17.0),
//               ),
//             );
//             mapController.addMarker(MarkerOptions(
//               position: places[index].nearbyCoordinates,
//               infoWindowText: InfoWindowText(places[index].nearbyPlaces,
//                   places[index].nearbyTraffic),
//               icon: places[index].nearbyTraffic == 'Heavy'
//                   ? BitmapDescriptor.defaultMarkerWithHue(
//                       BitmapDescriptor.hueRed)
//                   : places[index].nearbyTraffic == 'Light'
//                       ? BitmapDescriptor.defaultMarkerWithHue(
//                           BitmapDescriptor.hueGreen)
//                       : BitmapDescriptor.defaultMarkerWithHue(
//                           BitmapDescriptor.hueYellow),
//             ));
//           },
//         );
//       },
//     );
//     return listview;
//   }

//   void handleBottomSheet() {
//     if (isBottomSheetVisible) {
//       _hideBottomSheet();
//     } else {
//       _showBottomSheet();
//     }
//   }

//   void _hideBottomSheet() {
//     persistentBottomSheetController.close();
//     _animationController.reverse();
//     persistentBottomSheetController.closed.whenComplete(() {
//       setState(() {
//         isBottomSheetVisible = false;
//       });
//       _animationController.reverse();
//     });
//   }

//   void _showBottomSheet() {
//     setState(() {
//       isBottomSheetVisible = true;
//     });
//     _animationController.forward();

//     persistentBottomSheetController = findDonorsScaffoldKey.currentState
//         .showBottomSheet<Null>((BuildContext context) {
//       return myBottomSheet();
//     });
//     persistentBottomSheetController.closed.whenComplete(() {
//       setState(() {
//         isBottomSheetVisible = false;
//       });
//       _animationController.reverse();
//     });
//   }

//   void _onMapCreated(GoogleMapController controller) async {
//     mapController = controller;
//   }
// }

// class PlacesSearch extends SearchDelegate<Place> {
//   final List<Place> places;
//   List<Place> filteredPlaces = [];
//   PlacesSearch({this.places});

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     assert(context != null);
//     final ThemeData theme = Theme.of(context).copyWith(
//         hintColor: Colors.white,
//         textTheme: TextTheme(
//           title: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
//         ));
//     assert(theme != null);
//     return theme;
//   }

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       )
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     if (query == '') {
//       return Container(
//         color: Colors.purple,
//         child: Center(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               width: 50,
//               height: 50,
//               child: Icon(
//                 Icons.search,
//                 size: 50,
//                 color: Colors.white,
//               ),
//             ),
//             Text(
//               'Enter a place to search.',
//               style: TextStyle(color: Colors.white),
//             )
//           ],
//         )),
//       );
//     } else {
//       filteredPlaces = [];
//       getFilteredList(places);
//       if (filteredPlaces.length == 0) {
//         return Container(
//           color: Colors.purple,
//           child: Center(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: Icon(
//                   Icons.sentiment_dissatisfied,
//                   size: 50,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 'No results found',
//                 style: TextStyle(color: Colors.white),
//               )
//             ],
//           )),
//         );
//       } else {
//         return Container(
//           color: Colors.purple,
//           child: ListView.builder(
//             itemCount:
//                 filteredPlaces.length == null ? 0 : filteredPlaces.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: Icon(
//                   Icons.directions_bus,
//                   color: Colors.white,
//                 ),
//                 trailing: IconButton(
//                   icon: Icon(
//                     Icons.arrow_forward_ios,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     // Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (context) => PlaceDetail(
//                     //               channel: IOWebSocketChannel.connect(
//                     //                   'ws://192.168.137.1:8080/'),
//                     //             )));
//                   },
//                 ),
//                 title: Text(
//                   filteredPlaces[index].nearbyPlaces,
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18.0,
//                       color: Colors.white),
//                 ),
//                 subtitle: Text(
//                   filteredPlaces[index].nearbyTraffic,
//                   style: TextStyle(fontSize: 14.0, color: Colors.grey),
//                 ),
//                 onTap: () {
//                   close(context, filteredPlaces[index]);
//                 },
//               );
//             },
//           ),
//         );
//       }
//     }
//   }

//   List<Place> getFilteredList(List<Place> place) {
//     for (int i = 0; i < place.length; i++) {
//       if (place[i].nearbyPlaces.toLowerCase().startsWith(query)) {
//         filteredPlaces.add(place[i]);
//       }
//     }
//     return filteredPlaces;
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query == '') {
//       return Container(
//         color: Colors.purple,
//         child: Center(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               width: 50,
//               height: 50,
//               child: Icon(
//                 Icons.search,
//                 size: 50,
//                 color: Colors.white,
//               ),
//             ),
//             Text(
//               'Enter a place to search.',
//               style: TextStyle(color: Colors.white),
//             )
//           ],
//         )),
//       );
//     } else {
//       filteredPlaces = [];
//       getFilteredList(places);
//       if (filteredPlaces.length == 0) {
//         return Container(
//           color: Colors.purple,
//           child: Center(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: Icon(
//                   Icons.sentiment_dissatisfied,
//                   size: 50,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 'No results found',
//                 style: TextStyle(color: Colors.white),
//               )
//             ],
//           )),
//         );
//       } else {
//         return Container(
//           color: Colors.purple,
//           child: ListView.builder(
//             itemCount:
//                 filteredPlaces.length == null ? 0 : filteredPlaces.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: Icon(
//                   Icons.directions_bus,
//                   color: Colors.white,
//                 ),
//                 trailing: IconButton(
//                   icon: Icon(
//                     Icons.arrow_forward_ios,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     // Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //         builder: (context) => PlaceDetail(
//                     //               channel: IOWebSocketChannel.connect(
//                     //                   'ws://192.168.137.1:8080/'),
//                     //             )));
//                   },
//                 ),
//                 title: Text(
//                   filteredPlaces[index].nearbyPlaces,
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18.0,
//                       color: Colors.white),
//                 ),
//                 subtitle: Text(
//                   filteredPlaces[index].nearbyTraffic,
//                   style: TextStyle(fontSize: 14.0, color: Colors.grey),
//                 ),
//                 onTap: () {
//                   close(context, filteredPlaces[index]);
//                 },
//               );
//             },
//           ),
//         );
//       }
//     }
//   }
// }
