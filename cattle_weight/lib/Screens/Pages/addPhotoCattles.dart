// หน้าเลือกภาพที่จะนำไปใช้คำนวณน้ำหนัก
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/GallorySolutions/PictureRef.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cattle_weight/Camera/cameraSide_screen.dart';
import 'package:cattle_weight/DataBase/catImage_handler.dart';
import 'package:cattle_weight/Screens/Pages/BlueAndCameraSolution/BluetoothPage.dart';
import 'package:cattle_weight/Screens/Pages/catImage_screen.dart';
import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:cattle_weight/model/catTime.dart';
import 'package:cattle_weight/model/image.dart';
import 'package:cattle_weight/model/imageNavidation.dart';
import 'package:cattle_weight/model/utility.dart';

ConvertHex hex = new ConvertHex();

class AddPhotoCattles extends StatefulWidget {
  final int idPro;
  final int idTime;

  const AddPhotoCattles({
    Key? key,
    required this.idPro,
    required this.idTime,
  }) : super(key: key);

  @override
  State<AddPhotoCattles> createState() => _AddPhotoCattlesState();
}

class _AddPhotoCattlesState extends State<AddPhotoCattles> {
  late Future<File> imageFile;

  late Image image;

  CatImageHelper? ImageHelper;
  CatTimeHelper? catTimeHelper;

  late List<ImageModel> images;
  ImageNavidation line = new ImageNavidation();
  late Future<CatTimeModel> catTimeData;

  @override
  void initState() {
    super.initState();
    images = [];
    ImageHelper = CatImageHelper();
    catTimeHelper = CatTimeHelper();
    refreshImages();
  }

  refreshImages() {
    catTimeData = catTimeHelper!.getCatTimeWithCatTimeID(widget.idTime);
    ImageHelper!.getCatTimePhotos(widget.idTime).then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: catTimeData,
        builder: (context, AsyncSnapshot<CatTimeModel> snapshot) {
          final picker = ImagePicker();

          Future<void> pickImageFromGallery() async {
            final pickedImage = await picker
                .getImage(
                    source: ImageSource.gallery,
                    maxHeight: 1080,
                    maxWidth: 2160,
                    imageQuality: 100)
                .then((imgFile) {
              if (imgFile == null) {
                Navigator.pop(context);
              } else {
                final file = File(imgFile.path);
                String imgString = Utility.base64String(file.readAsBytesSync());
                ImageModel photo = ImageModel(
                    idPro: widget.idPro,
                    idTime: snapshot.data!.id!,
                    imagePath: imgString);
                ImageHelper!.save(photo);

                catTimeHelper!.updateCatTime(CatTimeModel(
                    id: snapshot.data!.id!,
                    idPro: snapshot.data!.idPro,
                    weight: snapshot.data!.weight,
                    bodyLenght: snapshot.data!.bodyLenght,
                    heartGirth: snapshot.data!.heartGirth,
                    hearLenghtSide: snapshot.data!.hearLenghtSide,
                    hearLenghtRear: snapshot.data!.hearLenghtRear,
                    hearLenghtTop: snapshot.data!.hearLenghtTop,
                    pixelReference: snapshot.data!.pixelReference,
                    distanceReference: snapshot.data!.distanceReference,
                    imageSide: imgString,
                    imageRear: snapshot.data!.imageRear,
                    imageTop: snapshot.data!.imageTop,
                    date: snapshot.data!.date,
                    note: snapshot.data!.note));

                setState(() {
                  refreshImages();
                });

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GalloryRefSide(
                        imageFile: file,
                        fileName: file.path,
                        catTime: snapshot.data!)));
              }
            });
          }

          GalloryImage() {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "คุณสมบัติของภาพ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      '1. ภาพต้องไม่มืดหรือสว่างจนไม่เห็นตัวโค\n2. ภาพที่ถ่ายจากกล้องจะยังไม่สามารถนำมาคำนวนได้ ต้องบันทึกหน้าจอหรือแคปหน้าจอรูปที่ต้องการก่อน\n3.เมื่อบันทึกหน้าจอรูปที่ต้องการแล้วจึงจะนำมาคำนวณน้ำหนักได้',
                      style: TextStyle(fontSize: 18),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'ยกเลิก',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          pickImageFromGallery();
                        },
                        child: const Text(
                          'ตกลง',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  );
                });
          }

          if (snapshot.hasData) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: Image.asset("assets/images/camera01.png",
                          height: 240, width: 240, fit: BoxFit.cover)),
                  SizedBox(
                    height: 5,
                  ),
                  // ปุ่มถ่ายภาพ
                  MainButton(
                      onSelected: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BlueMainPage(
                                idPro: snapshot.data!.idPro,
                                idTime: snapshot.data!.id!,
                                catTime: snapshot.data!)
                            // CameraSideScreen(
                            //       idPro: widget.idPro,
                            //       idTime: widget.idTime,
                            //       localFront: line.sideLeft,
                            //       localBack: line.sideRight,
                            //       catTime: snapshot.data!,
                            //     )
                            ));
                      },
                      title: "ถ่ายภาพ"),
                  Center(
                      child: Image.asset("assets/images/photo01.png",
                          height: 240, width: 240, fit: BoxFit.cover)),
                  SizedBox(
                    height: 5,
                  ),
                  MainButton(
                      onSelected: () {
                        GalloryImage();
                      },
                      title: "นำเข้าภาพ"),
                ],
              ),
              backgroundColor: Color(hex.Blue()),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          }
        });
  }
}
