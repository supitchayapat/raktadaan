import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktadaan/screens/certificate.dart';
import 'package:raktadaan/screens/login_page.dart';
import 'package:raktadaan/widgets/profile_tile.dart';
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
    willDonate = preferences.getBool('online');
    final response = await http
        .get("http://192.168.137.169:3000/willchanger?user_id=$userId");
    if (response.statusCode == 200) {
      print('successful');
      preferences.setBool('online', !willDonate);
      if (this.mounted) {
        setState(() {
          willDonate = !willDonate;
        });
      }
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
      willDonate = preferences.getBool('online');
      setState(() {});
    } else {
      setState(() {});
    }
  }

  Widget profileBody() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom : 20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
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
                                          'http://192.168.137.169:3000/${userId.toString()}profile.jpg'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      ProfileTile(
                                        title: credits.toString(),
                                        subtitle: "Respect",
                                      ),
                                      ProfileTile(
                                        title: bloodGrp,
                                        subtitle: "Blood Group",
                                      ),
                                      ProfileTile(
                                        title: phoneNumber,
                                        subtitle: "Number",
                                      ),
                                    ],
                                  ),
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
                                          }),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Certificate()));
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        border: Border.all(
                                            width: 3,
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: AssetImage(
                                              'assets/images/winner.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Share your certificate',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print('tapped');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Certificate()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child:
                                                Icon(FontAwesomeIcons.facebook),
                                          ),
                                          Expanded(
                                            child:
                                                Icon(FontAwesomeIcons.linkedin),
                                          ),
                                          Expanded(
                                            child:
                                                Icon(FontAwesomeIcons.twitter),
                                          ),
                                          Expanded(
                                            child:
                                                Icon(FontAwesomeIcons.shareAlt),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        RaisedButton(
                          elevation: 5,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          onPressed: () {},
                          child: Text(
                            'REDEEM',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              fontFamily: 'Open Sans',
                            ),
                          ),
                        )
                      ],
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
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoggedIn == null
          ? Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : isLoggedIn
              ? profileBody()
              : Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(
                          FontAwesomeIcons.lock,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Log in to continue',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Open Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      RaisedButton(
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
