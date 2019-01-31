// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   // My IPv4 : 192.168.43.171
//   final String phpEndPoint = 'http://192.168.43.171/phpAPI/image.php';
//   final String nodeEndPoint = 'http://192.168.137.1:3000/image';
//   File file;
//
//   void _choose() async {
//     file = await ImagePicker.pickImage(source: ImageSource.camera);
// // file = await ImagePicker.pickImage(source: ImageSource.gallery);
//   }
//
//   void _upload() {
//     if (file == null) return;
//     String base64Image = base64Encode(file.readAsBytesSync());
//     String fileName = file.path.split("/").last;
//
//     http.post(nodeEndPoint, body: {
//       "image": base64Image,
//       "name": fileName,
//     }).then((res) {
//       print(res.statusCode);
//     }).catchError((err) {
//       print(err);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               RaisedButton(
//                 onPressed: _choose,
//                 child: Text('Choose Image'),
//               ),
//               SizedBox(width: 10.0),
//               RaisedButton(
//                 onPressed: _upload,
//                 child: Text('Upload Image'),
//               )
//             ],
//           ),
//           file == null ? Text('No Image Selected') : Image.file(file)
//         ],
//       ),
//     );
//   }
// }
