import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktadaan/screens/ambulances_screen.dart';
import 'package:raktadaan/screens/blood_banks.dart';
import 'package:raktadaan/screens/document_upload.dart';
import 'package:raktadaan/screens/donate_screen.dart';
import 'package:raktadaan/screens/events_page.dart';
import 'package:raktadaan/screens/find_donors.dart';
import 'package:raktadaan/screens/login_page.dart';
import 'package:raktadaan/screens/user_profile.dart';
import 'package:raktadaan/widgets/custom_curve.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var bloodGroups = ['O−', 'O+', 'A−', 'A+', 'B−', 'B+', 'AB−', 'AB+'];
  String selectedBloodGroup = 'O+';
  SharedPreferences preferences;
  bool isLoggedIn;
  int userId;
  _prepareSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      userId = preferences.getInt('userId');
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _prepareSharedPref();
  }

  void gotoProfile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserProfile()));
  }

  void gotoFindDonors() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FindDonorsPage()));
  }

  Widget bloodDropDown() {
    return Theme(
      data: ThemeData(
        canvasColor: Theme.of(context).primaryColor,
      ),
      child: DropdownButton<String>(
        //hint: Text('Select your blood type'),
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

  showPicker() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(dialogBackgroundColor: Color(0xFF7C0A02)),
            child: AlertDialog(
              content: BloodPicker(userId: userId),
            ),
          );
        });
  }

  Widget appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      actions: <Widget>[
        (isLoggedIn == false || userId == null)
            ? IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: Icon(FontAwesomeIcons.signInAlt),
              )
            : IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DocumentUpload()));
                },
                icon: Icon(FontAwesomeIcons.fileSignature),
              ),
      ],
      leading: (isLoggedIn == false || userId == null)
          ? Container()
          : InkWell(
              onTap: () {
                gotoProfile();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'http://192.168.137.169:3000/${userId.toString()}profile.jpg'),
                    ),
                  ),
                ),
              ),
            ),
      title: Text(
        'Raktadaan',
        style: TextStyle(fontSize: 24),
      ),
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
                    colors: [Color(0xFF7C0A02), Theme.of(context).primaryColor],
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Hero(
                        tag: 'icon',
                        child: Image(
                            width: 100.0,
                            height: 80.0,
                            fit: BoxFit.fitHeight,
                            image:
                                new AssetImage('assets/images/logo_drop.png')),
                      ),
                    ),
                    Center(
                      child: RaisedButton.icon(
                        color: Colors.white,
                        icon: Icon(FontAwesomeIcons.searchLocation),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        label: Text(
                          'Find Donors',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          showPicker();
                        },
                      ),
                    ),
                  ],
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
                                          builder: (context) =>
                                              BloodBanksPage()));
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
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Theme.of(context)
                                                        .primaryColor
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
                                          builder: (context) => DonatePage()));
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
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Theme.of(context)
                                                        .primaryColor
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
                                          builder: (context) =>
                                              AmbulancesPage()));
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
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Theme.of(context)
                                                        .primaryColor
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
                                          builder: (context) => Eventspage()));
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
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Theme.of(context)
                                                        .primaryColor
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

class BloodPicker extends StatefulWidget {
  final int userId;
  BloodPicker({this.userId});
  @override
  _BloodPickerState createState() => _BloodPickerState();
}

class _BloodPickerState extends State<BloodPicker> {
  var bloodGroups = ['O−', 'O+', 'A−', 'A+', 'B−', 'B+', 'AB−', 'AB+'];
  var distances = ['0.5', '1', '2', '5', '10', '15', '20', '50'];
  String selectedDistance = '2';
  String selectedBloodGroup = 'O+';
  bool isMale = true;

  void gotoFindDonors() {
    String gender;
    if (isMale) {
      gender = 'male';
    } else {
      gender = 'female';
    }
    int userId;
    if (widget.userId == null) {
      userId = 0;
    } else {
      userId = widget.userId;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FindDonorsPage(
                  bloodGrp: selectedBloodGroup,
                  userId: userId.toString(),
                  gender: gender,
                )));
  }

  Widget bloodDropDown(String ofWhat) {
    return Theme(
      data: ThemeData(
        canvasColor: Color(0xFF7C0A02),
      ),
      child: DropdownButton<String>(
          //hint: Text('Select your blood type'),
          style: TextStyle(
              color: Colors.white, fontFamily: 'Open Sans', fontSize: 16),
          items: ofWhat == 'blood'
              ? bloodGroups.map((String dropDownStringItem) {
                  return DropdownMenuItem(
                    value: dropDownStringItem,
                    child: Container(
                        child: Text(
                      dropDownStringItem,
                      style: TextStyle(fontFamily: 'Open Sans'),
                    )),
                  );
                }).toList()
              : distances.map((String dropDownStringItem) {
                  return DropdownMenuItem(
                    value: dropDownStringItem,
                    child: Container(
                        child: Text(
                      dropDownStringItem,
                      style: TextStyle(fontFamily: 'Open Sans'),
                    )),
                  );
                }).toList(),
          onChanged: (String selectedData) {
            setState(() {
              if (ofWhat == 'blood') {
                selectedBloodGroup = selectedData;
              } else {
                selectedDistance = selectedData;
              }
            });
          },
          value: ofWhat == 'blood' ? selectedBloodGroup : selectedDistance),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF7C0A02),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
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
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(
                            color: isMale ? Colors.white : Colors.transparent,
                            width: 2)),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.mars, color: Colors.white),
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
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(
                            color: !isMale ? Colors.white : Colors.transparent,
                            width: 2)),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.venus, color: Colors.white),
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
          Row(
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
              bloodDropDown('blood'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Diatance (in KM) : ',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              bloodDropDown('distance'),
            ],
          ),
          RaisedButton(
            color: Colors.purple,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
              child: Text(
                'Find Donors',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              gotoFindDonors();
            },
          )
        ],
      ),
    );
  }
}
