import 'package:flutter/material.dart';
import 'package:raktadaan/screens/login.dart';
import 'package:raktadaan/screens/messages_screen.dart';
import 'package:raktadaan/screens/user_profile.dart';
import 'package:raktadaan/widgets/custom_curve.dart';



class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  void gotoProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserProfile()));
  }

  void gotoFindDonors() {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => FindDonors()));
          }
        
          Widget appBar() {
            return AppBar(
              backgroundColor: Color(0xFF44A8FF),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MessagesPage()));
                  },
                  icon: Icon(Icons.message),
                )
              ],
              leading: InkWell(
                onTap: () {
                  gotoProfile();
                },
                child: Hero(
                  tag: 'profile_image1',
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        border: new Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/a/a0/Bill_Gates_2018.jpg'),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text('Raktadaan'),
              elevation: 0,
            );
          }
        
          Widget myBody() {
            return Column(
              children: <Widget>[
                //Upper Part
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ClipPath(
                      clipper: CustomShapeClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.blue, Color(0xFF44A8FF)],
                          ),
                        ),
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //       image: ExactAssetImage('assets/images/top_curve.png'),
                        //       fit: BoxFit.fill),
                        // ),
                        child: Center(
                          child: Card(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              width: 150.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  gotoFindDonors();
                                },
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      'Find Donors',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Lower Part
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          //Lower column 1st row
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  //Blood Banks
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          print('Tapped Blood Banks');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => LoginPage()));
                                        },
                                        child: Card(
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(8.0)),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        colorFilter:
                                                            new ColorFilter.mode(
                                                                Colors.blue
                                                                    .withOpacity(0.6),
                                                                BlendMode.dstATop),
                                                        image: ExactAssetImage(
                                                            'assets/images/hospital.jpeg'),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(8.0),
                                                  ),
                                                  child: Center(
                                                    child: Text('Blood Banks',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 24.0,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  //Donate
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          print('Tapped Donate');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => LoginPage()));
                                        },
                                        child: Card(
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(8.0)),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        colorFilter:
                                                            new ColorFilter.mode(
                                                                Colors.blue
                                                                    .withOpacity(0.6),
                                                                BlendMode.dstATop),
                                                        image: ExactAssetImage(
                                                            'assets/images/emergency.jpg'),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(8.0),
                                                  ),
                                                  child: Center(
                                                    child: Text('Donate',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 24.0,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  //Ambulances
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          print('Tapped Ambulance');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => LoginPage()));
                                        },
                                        child: Card(
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(8.0)),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        colorFilter:
                                                            new ColorFilter.mode(
                                                                Colors.blue
                                                                    .withOpacity(0.6),
                                                                BlendMode.dstATop),
                                                        image: ExactAssetImage(
                                                            'assets/images/ambulance.jpg'),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(8.0),
                                                  ),
                                                  child: Center(
                                                    child: Text('Ambulance',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 24.0,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  //events
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          print('Tapped Events');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => LoginPage()));
                                        },
                                        child: Card(
                                            elevation: 8,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(8.0)),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        colorFilter:
                                                            new ColorFilter.mode(
                                                                Colors.blue
                                                                    .withOpacity(0.6),
                                                                BlendMode.dstATop),
                                                        image: ExactAssetImage(
                                                            'assets/images/event.jpg'),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(8.0),
                                                  ),
                                                  child: Center(
                                                    child: Text('Events',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 24.0,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        
          @override
          Widget build(BuildContext context) {
            return Scaffold(
              appBar: appBar(),
              body: myBody(),
            );
          }
        }
        
        class FindDonors {
}
