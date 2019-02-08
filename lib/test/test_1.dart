import 'package:flutter/material.dart';
import 'package:raktadaan/test/test_2.dart';

class ActivePeople extends StatefulWidget {
  @override
  _ActivePeopleState createState() => _ActivePeopleState();
}

class _ActivePeopleState extends State<ActivePeople> {
  final _formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  bool isLoading = false;

  Widget myBody() {
    return Container(
      color: Color(0xFFC21807),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: userNameController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your name';
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'User Name',
                            hintText: 'Enter you user name',
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          child: RaisedButton(
                            color: Colors.purple,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ActiveDevices()
                              ));
                              if (_formKey.currentState.validate() &&
                                  !isLoading) {
                                setState(() {
                                  isLoading = true;
                                  // _getData();
                                });
                              }
                            },
                            child: isLoading
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Sign Up',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Devices'),
      ),
      body: myBody(),
    );
  }
}
