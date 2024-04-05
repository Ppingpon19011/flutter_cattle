import 'dart:io';
import 'dart:typed_data';

// import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cattle_weight/convetHex.dart';

ConvertHex hex = new ConvertHex();

class PreviewScreen extends StatefulWidget {
  final String imgPath;
  final String fileName;
  PreviewScreen({required this.imgPath, required this.fileName});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //     automaticallyImplyLeading: true,
        //     title: Text("ABC"),
        //     backgroundColor: Color(hex.hexColor("#FFC909"))),
        body: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: new RotatedBox(
                quarterTurns: -1,
                child: Image.file(
                  File(widget.imgPath),
                  fit: BoxFit.cover,
                ),
              )),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     width: double.infinity,
          //     height: 60,
          //     color: Color(hex.hexColor("#FFC909")),
          //     child: Row(children: [
          //       // Expanded(
          //       //   child: IconButton(
          //       //     icon: Icon(
          //       //       Icons.share,
          //       //       color: Colors.white,
          //       //     ),
          //       //     onPressed: () {
          //       //       getBytes().then((bytes) {
          //       //         print('here now');
          //       //         print(widget.imgPath);
          //       //         // print(bytes.buffer.asUint8List());
          //       //         Share.file('Share via', widget.fileName,
          //       //             bytes.buffer.asUint8List(), 'image/path');
          //       //       });
          //       //     },
          //       //   ),
          //       // ),
          //       // Expanded(
          //       //     child: IconButton(
          //       //         onPressed: () {}, icon: Icon(Icons.ac_unit))),
          //       // Expanded(
          //       //     child: IconButton(
          //       //         onPressed: () {}, icon: Icon(Icons.access_alarm))),
          //       // Expanded(
          //       //     child: IconButton(
          //       //         onPressed: () {},
          //       //         icon: Icon(Icons.offline_bolt_outlined))),
          //       // Expanded(
          //       //     child: IconButton(
          //       //         onPressed: () {}, icon: Icon(Icons.battery_alert))),
          //     ]),
          //   ),
          // )
        ],
      ),
    ));
  }

  Future getBytes() async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
//    print(ByteData.view(buffer))
    return ByteData.view(bytes.buffer);
  }
}
