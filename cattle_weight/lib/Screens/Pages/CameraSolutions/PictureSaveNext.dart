
import 'dart:io';
import 'dart:math';


import 'package:cattle_weight/Camera/cameraTop_screen.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/ProfilePage.dart';
import 'package:cattle_weight/Screens/Pages/catTime_screen.dart';
import 'package:cattle_weight/model/calculation.dart';
import 'package:cattle_weight/model/catTime.dart';
import 'package:cattle_weight/model/imageNavidation.dart';
import 'package:cattle_weight/model/utility.dart';
import 'package:flutter/material.dart';

import 'package:cattle_weight/Screens/Pages/viewPage.dart';
import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:cattle_weight/convetHex.dart';

ConvertHex hex = new ConvertHex();
CattleCalculation calculate = new CattleCalculation();
ImageNavidation line = new ImageNavidation();

class SaveNextCamera extends StatefulWidget {
  final int? catTimeID;
  const SaveNextCamera({
    Key? key,
    this.catTimeID,
  }) : super(key: key);

  @override
  _SaveNextCameraState createState() => _SaveNextCameraState();
}

class _SaveNextCameraState extends State<SaveNextCamera> {
  late CatTimeHelper catTimeHelper;
  late Future<CatTimeModel> catTimeData;

  Future loadData() async {
    catTimeData = catTimeHelper.getCatTimeWithCatTimeID(widget.catTimeID!);
  }

  @override
  void initState() {
    super.initState();
    catTimeHelper = new CatTimeHelper();

    loadData();
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
                                //       Navigator.of(context).push(
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   CameraTopScreen(
                                //                     idPro: snapshot.data.idPro,
                                //                     idTime: snapshot.data.id,
                                //                     localFront: line.TopRight,
                                //                     localBack: line.TopLeft,
                                //                     catTime: snapshot.data,
                                //                   )));
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
