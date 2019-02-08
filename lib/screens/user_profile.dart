import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  final double circleRadius = 125.0;
  final double circleBorderWidth = 4.0;
  SharedPreferences preferences;
  bool isLoggedIn;
  bool willDonate;
  String profileUrl, bloodGrp, phoneNumber, gender, name;
  int userId, credits;

  _setData() async {
    final response = await http
        .get("http://192.168.137.46:3000/willchanger?user_id=$userId");
    if (response.statusCode == 200) {
      print('successful');
    } else {
      print('Error');
    }
  }

  @override
  void initState() {
    super.initState();
    _prepareSharedPref();
  }

  _prepareSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      userId = preferences.getInt('userId');
      bloodGrp = preferences.getString('bloodGrp');
      gender = preferences.getString('userGender');
      credits = preferences.getInt('userCredit');
      name = preferences.getString('userName');
      phoneNumber = preferences.getString('userPhone');
      willDonate = preferences.getBool('willDonate') ?? true;
      setState(() {});
    }
  }

  Widget profileBody() {
    return Container(
      color: Color(0xFFC21807),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: circleRadius / 2.0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                    width: double.infinity,
                    height: double.infinity,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(top: circleRadius / 2),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Respect : ${credits.toString()}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Number : $phoneNumber',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Blood Group : $bloodGrp',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Row(
                                //     children: <Widget>[
                                //       Text(
                                //         'Willing to Donate : ',
                                //         style: TextStyle(
                                //             color: Colors.black,
                                //             fontFamily: 'Open Sans',
                                //             fontWeight: FontWeight.bold,
                                //             fontSize: 16),
                                //       ),
                                //       Expanded(
                                //         child: InkWell(
                                //           onTap: () {
                                //             setState(() {
                                //               willDonate = true;
                                //             });
                                //             preferences.setBool(
                                //                 'willDonate', true);
                                //           },
                                //           child: Container(
                                //             decoration: BoxDecoration(
                                //                 borderRadius: BorderRadius.all(
                                //                     Radius.circular(8.0)),
                                //                 border: Border.all(
                                //                     color: willDonate
                                //                         ? Colors.black
                                //                         : Colors.transparent,
                                //                     width: 2)),
                                //             height: 50,
                                //             width: double.infinity,
                                //             child: Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.center,
                                //               children: <Widget>[
                                //                 Icon(Icons.done,
                                //                     color: Colors.black),
                                //                 Text(
                                //                   'Yes',
                                //                   style: TextStyle(
                                //                       color: Colors.black,
                                //                       fontFamily: 'Open Sans',
                                //                       fontWeight:
                                //                           FontWeight.bold,
                                //                       fontSize: 14),
                                //                 )
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //       Expanded(
                                //         child: InkWell(
                                //           onTap: () {
                                //             setState(() {
                                //               willDonate = false;
                                //               preferences.setBool(
                                //                   'willDonate', false);
                                //             });
                                //           },
                                //           child: Container(
                                //             decoration: BoxDecoration(
                                //                 borderRadius: BorderRadius.all(
                                //                     Radius.circular(8.0)),
                                //                 border: Border.all(
                                //                     color: !willDonate
                                //                         ? Colors.black
                                //                         : Colors.transparent,
                                //                     width: 2)),
                                //             height: 50,
                                //             width: double.infinity,
                                //             child: Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.center,
                                //               children: <Widget>[
                                //                 Icon(Icons.clear,
                                //                     color: Colors.black),
                                //                 Text(
                                //                   'No',
                                //                   style: TextStyle(
                                //                       color: Colors.black,
                                //                       fontFamily: 'Open Sans',
                                //                       fontWeight:
                                //                           FontWeight.bold,
                                //                       fontSize: 14),
                                //                 )
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      'Willing to Donate : ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Switch.adaptive(
                                        value: willDonate,
                                        inactiveThumbColor: Colors.red,
                                        onChanged: (bool value) {
                                          _setData();
                                          preferences.setBool(
                                              'willDonate', value);
                                          setState(() {
                                            willDonate = value;
                                          });
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Hero(
                  tag: 'profile_image',
                  child: Container(
                    width: circleRadius,
                    height: circleRadius,
                    decoration: ShapeDecoration(
                        shape: CircleBorder(), color: Colors.white),
                    child: Padding(
                      padding: EdgeInsets.all(circleBorderWidth),
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (isLoggedIn == null && userId == null)
                                ? AssetImage('assets/images/face1.jpeg')
                                : NetworkImage(
                                    'http://192.168.137.46:3000/${userId.toString()}profile.jpg'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  child: RaisedButton(
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        'LOG OUT',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      preferences.setBool('isLoggedIn', false);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFFC21807),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.edit),
          )
        ],
        elevation: 0,
      ),
      body: isLoggedIn == null
          ? Container(
              color: Color(0xFFC21807),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : isLoggedIn
              ? profileBody()
              : Container(
                  color: Color(0xFFC21807),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Log in to continue'),
                      RaisedButton(
                        child: Text('Sign In'),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
    );
  }
}
