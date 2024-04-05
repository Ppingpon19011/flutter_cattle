import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:cattle_weight/BlueCamera/BlueCapturesSide_screen.dart';
import 'package:cattle_weight/DataBase/catImage_handler.dart';
import 'package:cattle_weight/DataBase/catImage_handler.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/BlueAndCameraSolution/BluePictureRefSide.dart';
import 'package:cattle_weight/Screens/Pages/CameraSolutions/PictureRef.dart';
import 'package:cattle_weight/Screens/Pages/catTime_screen.dart';
import 'package:cattle_weight/model/catTime.dart';
import 'package:cattle_weight/model/image.dart';
import 'package:cattle_weight/model/utility.dart';

import '../Camera/capturesSide_screen.dart';

class BluePreviewSideScreen extends StatefulWidget {
  final int idPro;
  final int idTime;
  final File imageFile;
  final List<File> fileList;
  final CatTimeModel catTime;
  final BluetoothDevice server;
  final bool blueConnection;
  final double heightValue;
  const BluePreviewSideScreen({
    Key? key,
    required this.idPro,
    required this.idTime,
    required this.imageFile,
    required this.fileList,
    required this.catTime,
    required this.server,
    required this.blueConnection,
    required this.heightValue,
  }) : super(key: key);

  @override
  State<BluePreviewSideScreen> createState() => _BluePreviewSideScreenState();
}

class _BluePreviewSideScreenState extends State<BluePreviewSideScreen> {
  CatImageHelper ImageHelper = CatImageHelper();
  CatTimeHelper? catTimeHelper;
  late List<ImageModel> images;

  @override
  void initState() {
    // TODO: implement initState
    ImageHelper = CatImageHelper();
    catTimeHelper = new CatTimeHelper();
    refreshImages();
    super.initState();
  }

  refreshImages() {
    ImageHelper.getCatTimePhotos(widget.idTime).then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preview"), actions: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BlueCapturesSideScreen(
                        idPro: widget.idPro,
                        idTime: widget.idTime,
                        imageFileList: widget.fileList,
                        catTime: widget.catTime,
                        server: widget.server,
                        blueConnection: widget.blueConnection,
                        heightValue: widget.heightValue,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.photo)),
            IconButton(
                onPressed: () async {
                  final file = widget.imageFile;
                  String imgString =
                      Utility.base64String(file.readAsBytesSync());
                  ImageModel photo = ImageModel(
                      idPro: widget.idPro,
                      idTime: widget.idTime,
                      imagePath: imgString);

                  await ImageHelper.save(photo);

                  // print("imgString : $imgString");
                  await catTimeHelper!.updateCatTime(CatTimeModel(
                      id: widget.catTime.id,
                      idPro: widget.catTime.idPro,
                      weight: widget.catTime.weight,
                      bodyLenght: widget.catTime.bodyLenght,
                      heartGirth: widget.catTime.heartGirth,
                      hearLenghtSide: widget.catTime.hearLenghtSide,
                      hearLenghtRear: widget.catTime.hearLenghtRear,
                      hearLenghtTop: widget.catTime.hearLenghtTop,
                      pixelReference: widget.catTime.pixelReference,
                      distanceReference: widget.heightValue,
                      imageSide: imgString,
                      imageRear: widget.catTime.imageRear,
                      imageTop: widget.catTime.imageTop,
                      date: DateTime.now().toIso8601String(),
                      note: widget.catTime.note));

                  setState(() {
                    refreshImages();
                  });

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BluePictureRefSide(
                            imageFile: file,
                            fileName: file.path,
                            catTime: widget.catTime,
                            server: widget.server,
                            blueConnection: widget.blueConnection,
                            
                          )));

                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (context) => CatTimeScreen(catProId: widget.idPro,)),
                  //     (Route<dynamic> route) => false);

                  // Navigator.pop(context);
                },
                icon: Icon(Icons.save))
          ],
        )
      ]),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextButton(
          //     onPressed: () {},
          //     child: Text('Go to all captures'),
          //     style: TextButton.styleFrom(
          //       primary: Colors.black,
          //       backgroundColor: Colors.white,
          //     ),
          //   ),
          // ),
          Expanded(
            child: Image.file(widget.imageFile),
          ),
        ],
      ),
    );
  }
}
