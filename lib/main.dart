import 'package:flutter/material.dart';
import 'package:raktadaan/screens/home_page.dart';
import 'package:raktadaan/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLoggedIn;
void main() {
  test();
}

test() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomePage(),
        '/login':(context) => LoginPage()
      },
      debugShowCheckedModeBanner: false,
      title: 'Raktadaan',
      theme: ThemeData(
        primaryColor: Color(0xFFC21807)
      ),
      home: isLoggedIn ? HomePage() : LoginPage(),
    );
  }
}
