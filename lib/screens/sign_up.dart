import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktadaan/screens/terms.dart';

class SignUpPage extends StatefulWidget {
  final String name, number;
  SignUpPage({this.name, this.number});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  File profileImageFile, citizenshipFrontFile, citizenshipBackImageFile;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _agreement = false;
  final String nodeEndPoint = 'http://192.168.137.169:3000/image';
  final String signUpPoint = 'http://192.168.137.169:3000/signup';
  var bloodGroups = ['O−', 'O+', 'A−', 'A+', 'B−', 'B+', 'AB−', 'AB+'];
  String selectedBloodGroup;
  bool isMale = true;
  var currentLocation;
  @override
  void initState() {
    super.initState();
    Geolocator().getLastKnownPosition().then((curloc) {
      currentLocation = curloc;
    });
    String name = widget.name;
    String number = widget.number;
    fullNameController.text = name;
    phoneNumberController.text = number;
  }

  void _upload(
      String fullName, String number, String bloodGroup, String password) {
    //print('$fullName$number$bloodGroup$password');

    String base64Image = base64Encode(profileImageFile.readAsBytesSync());
    String fileName = profileImageFile.path.split("/").last;
    String base64ImageCitFront =
        base64Encode(citizenshipFrontFile.readAsBytesSync());
    String fileNameCitFront = citizenshipFrontFile.path.split("/").last;
    String base64ImageCitBack =
        base64Encode(citizenshipBackImageFile.readAsBytesSync());
    String fileNameCitBack = citizenshipBackImageFile.path.split("/").last;
    String gender;
    if (isMale) {
      gender = 'male';
    } else {
      gender = 'female';
    }

    http.post(signUpPoint, body: {
      "name": fullName,
      "number": number,
      "long": currentLocation.longitude.toString(),
      "lat": currentLocation.latitude.toString(),
      "blood_grp": bloodGroup,
      "gender": gender,
      "password": password,
      "image": base64Image,
      "imageName": fileName,
      "image_citFront": base64ImageCitFront,
      "imageName_citFront": fileNameCitFront,
      "image_citBack": base64ImageCitBack,
      "imageName_citBack": fileNameCitBack,
    }).then((res) {
      print(res.statusCode);
      setState(() {
        isLoading = false;
      });
      if (res.statusCode == 200) {
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
              "Signed Up Succesfully!",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "Happy Helping!",
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

  picker(String source, String ofWhat) async {
    File img;
    if (source == 'camera') {
      img = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      img = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    if (img != null) {
      if (ofWhat == 'profile') {
        profileImageFile = img;
      } else if (ofWhat == 'citFront') {
        citizenshipFrontFile = img;
      } else {
        citizenshipBackImageFile = img;
      }
      setState(() {});
    }
  }

  showPicker(String ofWhat) {
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
                      picker('camera', ofWhat);
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
                        picker('gallery', ofWhat);
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

  Widget bloodDropDown() {
    return Theme(
      data: ThemeData(
        canvasColor: Theme.of(context).primaryColor,
      ),
      child: DropdownButton<String>(
        hint: Text('Select your blood type'),
        style: TextStyle(
            color: Colors.white, fontFamily: 'Open Sans', fontSize: 16),
        items: bloodGroups.map((String dropDownStringItem) {
          return DropdownMenuItem(
            value: dropDownStringItem,
            child: Container(
                child: Text(
              dropDownStringItem,
              style: TextStyle(fontFamily: 'Open Sans'),
            )),
          );
        }).toList(),
        onChanged: (String selectedBlood) {
          setState(() {
            selectedBloodGroup = selectedBlood;
          });
        },
        value: selectedBloodGroup,
      ),
    );
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showPicker('profile');
                          },
                          child: profileImageFile == null
                              ? CircleAvatar(
                                  radius: 60,
                                  child: Icon(
                                    Icons.add,
                                    size: 50,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 60,
                                  backgroundImage: FileImage(profileImageFile),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Gender : ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isMale = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      border: Border.all(
                                          color: isMale
                                              ? Colors.white
                                              : Colors.transparent,
                                          width: 2)),
                                  height: 50,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.mars,
                                          color: Colors.white),
                                      Text(
                                        'Male',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isMale = false;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      border: Border.all(
                                          color: !isMale
                                              ? Colors.white
                                              : Colors.transparent,
                                          width: 2)),
                                  height: 50,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.venus,
                                          color: Colors.white),
                                      Text(
                                        'Female',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            labelText: 'Full Name',
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
                          // initialValue: "widget.number",
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your Phone number';
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: _obscurePassword,
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a password';
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter the password',
                            prefixIcon: Icon(
                              Icons.security,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_obscurePassword) {
                                    _obscurePassword = false;
                                  } else {
                                    _obscurePassword = true;
                                  }
                                });
                              },
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Blood Group : ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            bloodDropDown(),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Citizenship Front',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showPicker('citFront');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2)),
                                      height: 100,
                                      width: double.infinity,
                                      child: citizenshipFrontFile == null
                                          ? Icon(
                                              Icons.add,
                                              size: 50,
                                              color: Colors.white,
                                            )
                                          : Image.file(citizenshipFrontFile),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Citizenship Back',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showPicker('citBack');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2)),
                                      height: 100,
                                      width: double.infinity,
                                      child: citizenshipBackImageFile == null
                                          ? Icon(
                                              Icons.add,
                                              size: 50,
                                              color: Colors.white,
                                            )
                                          : Image.file(
                                              citizenshipBackImageFile),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            onChanged: (bool value) {
                              setState(() {
                                _agreement = value;
                              });
                            },
                            value: _agreement,
                          ),
                          Text('I agree to the ',
                              style: TextStyle(color: Colors.white)),
                          InkWell(
                            child: Text('terms and conditions.',
                                style: TextStyle(color: Colors.blue)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TermsPage()));
                            },
                          )
                        ],
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
                                isLoading ? 'Loading...' : 'SIGN UP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate() &&
                                  profileImageFile != null &&
                                  citizenshipBackImageFile != null &&
                                  citizenshipFrontFile != null &&
                                  !isLoading &&
                                  selectedBloodGroup != null &&
                                  _agreement) {
                                setState(() {
                                  isLoading = true;
                                });
                                _upload(
                                    fullNameController.text,
                                    phoneNumberController.text,
                                    selectedBloodGroup,
                                    passwordController.text);
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
        title: Text('Sign Up'),
      ),
      body: mySignUpBody(),
    );
  }
}
