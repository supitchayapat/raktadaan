import 'package:flutter/material.dart';
import 'package:raktadaan/screens/image_picker.dart';

class LoginPage extends StatelessWidget {
  Widget myBody(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: Color(0xFF44A8FF),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter the username',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter the password',
                          prefixIcon: Icon(
                            Icons.security,
                            color: Colors.white,
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    //SignIn Button
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: new InkWell(
                        onTap: () => print('hello'),
                        child: new Container(
                          width: 150.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            //color: Color(0xFFff9b44),
                            color: Colors.transparent,
                            border:
                                new Border.all(color: Colors.white, width: 2.0),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: new Center(
                            child: new Text(
                              'Sign In',
                              style: new TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: new InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => CameraApp()
                          ));
                        },
                        child: new Container(
                          width: 100.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            //color: Color(0xFFff9b44),
                            color: Colors.transparent,
                            border:
                                new Border.all(color: Colors.white, width: 2.0),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: new Center(
                            child: new Text(
                              'Sign Up',
                              style: new TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF44A8FF),
        centerTitle: true,
        title: Text('Login'),
        elevation: 0,
      ),
      body: myBody(context),
    );
  }
}
