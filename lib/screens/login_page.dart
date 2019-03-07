import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raktadaan/screens/sign_up.dart';
import 'package:raktadaan/utils/bubble_indication_painter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController loginPhoneController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController signUpNameController = TextEditingController();
  TextEditingController signUpNumberController = TextEditingController();
  bool isLoading = false;
  bool _obscureTextLogin = true;

  PageController _pageController;
  SharedPreferences preferences;

  Color left = Colors.black;
  Color right = Colors.white;
  final String logInPoint = 'http://192.168.137.169:3000/login';
  _sendData(String username, String password) async {
    http.post(logInPoint,
        body: {"number": username, "password": password}).then((res) {
      if (res.body == 'user not found') {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Something is incorrect'),
        ));
      } else {
        Map<String, dynamic> user = jsonDecode(res.body);
        preferences.setInt('userId', user['id']);
        preferences.setString('bloodGrp', user['blood_grp']);
        preferences.setString('userGender', user['gender']);
        preferences.setInt('userCredit', user['credits']);
        preferences.setString('userName', user['name']);
        preferences.setBool('isLoggedIn', true);
        preferences.setBool('online', user['online']);
        preferences.setString('userPhone', username);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        // print('Howdy, ${user['id']}!');
        // print('We sent the verification link to ${user['gender']}.');
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    });
  }

  _prepareSharedPrefs() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF7C0A02), Theme.of(context).primaryColor],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 75.0),
                  child: Hero(
                    tag: 'icon',
                    child: Image(
                        width: 250.0,
                        height: 191.0,
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/images/logo_drop.png')),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: _buildMenuBar(context),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = Colors.black;
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignIn(context),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignUp(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _prepareSharedPrefs();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          controller: loginPhoneController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.phone,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                                fontSize: 17.0,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontSize: 17.0,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextLogin
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170.0),
                child: RaisedButton(
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        isLoading ? "LOGGING IN...." : "LOGIN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      if (loginPhoneController.text.isNotEmpty &&
                          loginPasswordController.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        _sendData(loginPhoneController.text.toString(),
                            loginPasswordController.text.toString());
                      }
                    }),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false);
                    },
                    child: Text(
                      "Skip this step",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          controller: signUpNameController,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Full Name",
                            hintStyle: TextStyle(
                                fontSize: 17.0,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          controller: signUpNumberController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.phone,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                                fontSize: 17.0,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170.0),
                child: RaisedButton(
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    String name = signUpNameController.text.toString();
                    String number = signUpNumberController.text.toString();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpPage(
                                  name: name,
                                  number: number,
                                )));
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false);
                    },
                    child: Text(
                      "Skip this step",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }
}
