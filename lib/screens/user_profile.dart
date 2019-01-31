import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  final double circleRadius = 125.0;
  final double circleBorderWidth = 4.0;

  Widget profileBody() {
    return Container(
      color: Color(0xFF44A8FF),
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
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Bill Gates',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                            ],
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
                            image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/a/a0/Bill_Gates_2018.jpg',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
        backgroundColor: Color(0xFF44A8FF),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.edit),
          )
        ],
        elevation: 0,
      ),
      body: profileBody(),
    );
  }
}
