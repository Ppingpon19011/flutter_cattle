
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:cattle_weight/Camera/cameraTop_screen.dart';
import 'package:cattle_weight/DataBase/catImage_handler.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/GallorySolutions/PictureTWTop.dart';
import 'package:cattle_weight/Screens/Pages/ProfilePage.dart';
import 'package:cattle_weight/Screens/Pages/catTime_screen.dart';
import 'package:cattle_weight/model/calculation.dart';
import 'package:cattle_weight/model/catTime.dart';
import 'package:cattle_weight/model/image.dart';
import 'package:cattle_weight/model/imageNavidation.dart';
import 'package:cattle_weight/model/utility.dart';
import 'package:flutter/material.dart';

import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:image_picker/image_picker.dart';

ConvertHex hex = new ConvertHex();
CattleCalculation calculate = new CattleCalculation();
ImageNavidation line = new ImageNavidation();

class SaveNextGallory extends StatefulWidget {
  final int? catTimeID;
  const SaveNextGallory({
    Key? key,
    this.catTimeID,
  }) : super(key: key);

  @override
  _SaveNextGalloryState createState() => _SaveNextGalloryState();
}

class _SaveNextGalloryState extends State<SaveNextGallory> {
  late CatTimeHelper catTimeHelper;
  late CatImageHelper ImageHelper;
  late Future<CatTimeModel> catTimeData;
  late List<ImageModel> images;
  ImageNavidation line = new ImageNavidation();

  @override
  void initState() {
    super.initState();
    catTimeHelper = new CatTimeHelper();
    ImageHelper = new CatImageHelper();
    refreshImages();
  }

  refreshImages() {
    catTimeData = catTimeHelper.getCatTimeWithCatTimeID(widget.catTimeID!);
    ImageHelper.getCatTimePhotos(widget.catTimeID!).then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("คำนวณ",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Color(hex.hexColor("#007BA4")),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
              future: catTimeData,
              builder: (context, AsyncSnapshot<CatTimeModel> snapshot) {
                final picker = ImagePicker();

                Future<void> pickImageFromGallery() async {
                  final pickedImage = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 1080,
                          maxWidth: 2160,
                          imageQuality: 100)
                      .then((imgFile) {
                    if (imgFile == null) {
                      Navigator.pop(context);
                    } else {
                      final file = File(imgFile.path);
                      String imgString =
                          Utility.base64String(file.readAsBytesSync());
                      ImageModel photo = ImageModel(
                          idPro: snapshot.data!.idPro,
                          idTime: snapshot.data!.id!,
                          imagePath: imgString);
                      ImageHelper.save(photo);

                      catTimeHelper.updateCatTime(CatTimeModel(
                          id: snapshot.data!.id,
                          idPro: snapshot.data!.idPro,
                          weight: snapshot.data!.weight,
                          bodyLenght: snapshot.data!.bodyLenght,
                          heartGirth: snapshot.data!.heartGirth,
                          hearLenghtSide: snapshot.data!.hearLenghtSide,
                          hearLenghtRear: snapshot.data!.hearLenghtRear,
                          hearLenghtTop: snapshot.data!.hearLenghtTop,
                          pixelReference: snapshot.data!.pixelReference,
                          distanceReference: snapshot.data!.distanceReference,
                          imageSide: snapshot.data!.imageSide,
                          imageRear: snapshot.data!.imageRear,
                          imageTop: imgString,
                          date: DateTime.now().toIso8601String(),
                          note: snapshot.data!.note));

                      setState(() {
                        refreshImages();
                      });

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GalloryTWTop(
                              imageFile: file,
                              fileName: file.path,
                              catTime: snapshot.data)));
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
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                  double hg = calculate.calHeartGirth(
                      snapshot.data!.hearLenghtRear,
                      snapshot.data!.hearLenghtSide);

                  return Center(
                    child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PhysicalModel(
                              color: Colors.teal,
                              elevation: 8,
                              shadowColor: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                  height: 240,
                                  width: 360,
                                  child: Center(
                                      child: ListTile(
                                    title: RotatedBox(
                                      quarterTurns: -1,
                                      child: Image.asset(
                                        "assets/images/SideLeftNavigation3.png",
                                        height: 120,
                                        width: 180,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "รอบอก: ${hg.toStringAsFixed(3)} ซม.",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                                  color: Colors.white)),
                          SizedBox(
                            height: 16,
                          ),
                          PhysicalModel(
                            color: Colors.teal,
                            elevation: 8,
                            shadowColor: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                                height: 240,
                                width: 360,
                                child: Center(
                                    child: ListTile(
                                  title: RotatedBox(
                                    quarterTurns: -1,
                                    child: Image.asset(
                                      "assets/images/SideLeftNavigation4.png",
                                      height: 120,
                                      width: 180,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "ความยาวลำตัว: ${snapshot.data!.bodyLenght.toStringAsFixed(3)} ซม.",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )),
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MainButton(
                                    onSelected: () async {
                                      double weight = calculate.calWeight(
                                          snapshot.data!.bodyLenght, hg);

                                      print("Cattle Weight: $weight Kg.");

                                      await catTimeHelper.updateCatTime(
                                          CatTimeModel(
                                              id: snapshot.data!.id,
                                              idPro: snapshot.data!.idPro,
                                              weight: weight,
                                              bodyLenght:
                                                  snapshot.data!.bodyLenght,
                                              heartGirth: hg,
                                              hearLenghtSide:
                                                  snapshot.data!.hearLenghtSide,
                                              hearLenghtRear:
                                                  snapshot.data!.hearLenghtRear,
                                              hearLenghtTop:
                                                  snapshot.data!.hearLenghtTop,
                                              pixelReference:
                                                  snapshot.data!.pixelReference,
                                              distanceReference: snapshot
                                                  .data!.distanceReference,
                                              imageSide:
                                                  snapshot.data!.imageSide,
                                              imageRear:
                                                  snapshot.data!.imageRear,
                                              imageTop: snapshot.data!.imageTop,
                                              date: DateTime.now()
                                                  .toIso8601String(),
                                              note: snapshot.data!.note));
                                      // Navigator.pushAndRemoveUntil จะไม่สามารถย้อนกลับมายัง Screen เดิมได้
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CattleProfilPage(
                                                    catProID:
                                                        snapshot.data!.idPro,
                                                  )),
                                          (route) => false);
                                    },
                                    title: "คำนวณน้ำหนัก", pixelDistance: 10,),
                                SizedBox(
                                  height: 10,
                                ),
                                // MainButton(
                                //     onSelected: () {
                                //       GalloryImage();
                                //     },
                                //     title: "ถ่ายภาพกระดูกสันหลังโค"),
                              ])
                        ]),
                  );
                } else {
                  return Container();
                }
              }),
        ));
  }
}
