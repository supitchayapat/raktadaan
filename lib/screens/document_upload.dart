import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentUpload extends StatefulWidget {
  @override
  _DocumentUploadState createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  File documentFile;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  bool isLoading = false;
  final String documentUploadPoint = 'http://192.168.137.169:3000/donorproof';

  bool isMale = true;

  void _upload(String fullName, String number) {
    String base64ImageDocument = base64Encode(documentFile.readAsBytesSync());
    String documentName = documentFile.path.split("/").last;

    http.post(documentUploadPoint, body: {
      "id": userId.toString(),
      "name": fullName,
      "number": number,
      "image": base64ImageDocument,
      "imageName": documentName,
    }).then((res) {
      print(res.statusCode);
      setState(() {
        isLoading = false;
      });
      if (res.statusCode == 200) {
        print('done');
        _showDialog();
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Something went wrong'),
        ));
      }
    }).catchError((err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<bool> _willPopCallback() async {
    return false;
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: _willPopCallback,
          child: AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "Submitted Successfully!",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "You application has been submitted successfully. Please wait till we review the legitimacy of your claim.",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  SharedPreferences preferences;
  bool isLoggedIn;
  int userId;

  _prepareSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      userId = preferences.getInt('userId');
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _prepareSharedPref();
  }

  picker(String source) async {
    File img;
    if (source == 'camera') {
      img = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      img = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    documentFile = img;
    setState(() {});
  }

  showPicker() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Pick a source')),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    child: Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      picker('camera');
                    },
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.camera_alt,
                            size: 50,
                          ),
                          Text('Camera')
                        ],
                      ),
                    ),
                  ),
                )),
                Expanded(
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        picker('gallery');
                      },
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.image,
                              size: 50,
                            ),
                            Text('Gallery')
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget mySignUpBody() {
    return Container(
      color: Theme.of(context).primaryColor,
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Hospital Bill / Receipt',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showPicker();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2)),
                                      height: 300,
                                      width: double.infinity,
                                      child: documentFile == null
                                          ? Icon(
                                              Icons.add,
                                              size: 50,
                                              color: Colors.white,
                                            )
                                          : Image.file(documentFile),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: fullNameController,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your name';
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Full Name of reciever',
                            hintText: 'Enter you full name',
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
                        child: TextFormField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your Phone number';
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Phone Number of receiver',
                            hintText: 'Enter your phone number',
                            prefixIcon: Icon(
                              Icons.phone,
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
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 42.0),
                              child: Text(
                                isLoading ? 'Loading...' : 'UPLOAD',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate() &&
                                  documentFile != null &&
                                  !isLoading) {
                                setState(() {
                                  isLoading = true;
                                });
                                String fullName =
                                    fullNameController.text.toString();
                                String number =
                                    phoneNumberController.text.toString();

                                _upload(fullName, number);
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Something is not right.'),
                                ));
                              }
                            },
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Donor Claim'),
      ),
      body: mySignUpBody(),
    );
  }
}
