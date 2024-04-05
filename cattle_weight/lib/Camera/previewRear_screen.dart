import 'dart:io';

import 'package:cattle_weight/Camera/capturesRear_screen.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/CameraSolutions/PictureRefRear.dart';
import 'package:cattle_weight/model/catTime.dart';
import 'package:flutter/material.dart';

import 'package:cattle_weight/DataBase/catImage_handler.dart';
import 'package:cattle_weight/DataBase/catImage_handler.dart';
import 'package:cattle_weight/Screens/Pages/CameraSolutions/PictureRef.dart';
import 'package:cattle_weight/Screens/Pages/catTime_screen.dart';
import 'package:cattle_weight/model/image.dart';
import 'package:cattle_weight/model/image.dart';
import 'package:cattle_weight/model/utility.dart';

import '../Camera/capturesSide_screen.dart';

class PreviewRearScreen extends StatefulWidget {
  final int idPro;
  final int idTime;
  final File imageFile;
  final List<File> fileList;
  final CatTimeModel catTime;
  const PreviewRearScreen({
    Key? key,
    required this.idPro,
    required this.idTime,
    required this.imageFile,
    required this.fileList,
    required this.catTime,
  }) : super(key: key);

  @override
  State<PreviewRearScreen> createState() => _PreviewRearScreenState();
}

class _PreviewRearScreenState extends State<PreviewRearScreen> {
  CatImageHelper ImageHelper = CatImageHelper();
  CatTimeHelper? catTimeHelper;
  late List<ImageModel> images;
  late Future<CatTimeModel> catTimeData;

  @override
  void initState() {
    // TODO: implement initState
    ImageHelper = CatImageHelper();
    catTimeHelper = new CatTimeHelper();
    refreshImages();
    loadData();
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

  loadData() async {
    catTimeData = catTimeHelper!.getCatTimeWithCatTimeID(widget.catTime.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preview"), actions: [
        FutureBuilder(
            future: catTimeData,
            builder: (context, AsyncSnapshot<CatTimeModel> snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => CapturesRearScreen(
                                idPro: widget.idPro,
                                idTime: widget.idTime,
                                imageFileList: widget.fileList,
                                catTime: snapshot.data!,
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
                              id: snapshot.data!.id,
                              idPro: snapshot.data!.idPro,
                              weight: snapshot.data!.weight,
                              bodyLenght: snapshot.data!.bodyLenght,
                              heartGirth: snapshot.data!.heartGirth,
                              hearLenghtSide: snapshot.data!.hearLenghtSide,
                              hearLenghtRear: snapshot.data!.hearLenghtRear,
                              hearLenghtTop: snapshot.data!.hearLenghtTop,
                              pixelReference: snapshot.data!.pixelReference,
                              distanceReference:
                                  snapshot.data!.distanceReference,
                              imageSide: snapshot.data!.imageSide,
                              imageRear: imgString,
                              imageTop: snapshot.data!.imageTop,
                              date: DateTime.now().toIso8601String(),
                              note: snapshot.data!.note));

                          setState(() {
                            refreshImages();
                          });

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PictureRefRear(
                                    imageFile: file,
                                    fileName: file.path,
                                    catTime: snapshot.data!,
                                  )));

                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(builder: (context) => CatTimeScreen(catProId: widget.idPro,)),
                          //     (Route<dynamic> route) => false);

                          // Navigator.pop(context);
                        },
                        icon: Icon(Icons.save))
                  ],
                );
              } else {
                return Container();
              }
            })
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
