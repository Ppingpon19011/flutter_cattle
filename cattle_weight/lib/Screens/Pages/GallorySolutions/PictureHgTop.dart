// @dart=2.9
import 'package:camera/camera.dart';
import 'package:cattle_weight/Camera/cameraRear_screen.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/catTime_screen.dart';
import 'package:cattle_weight/Screens/Pages/ProfilePage.dart';
import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:cattle_weight/Screens/Widgets/PaintLine.dart';
import 'package:cattle_weight/Screens/Widgets/PaintPoint.dart';
import 'package:cattle_weight/Screens/Widgets/position.dart';
import 'package:cattle_weight/Screens/Widgets/preview.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:cattle_weight/model/calculation.dart';
import 'package:cattle_weight/model/catTime.dart';
import 'package:cattle_weight/model/imageNavidation.dart';
import 'package:flutter/material.dart';

import 'dart:ffi';
import 'dart:math';

ConvertHex hex = new ConvertHex();
Positions pos = new Positions();
CattleCalculation calculate = new CattleCalculation();

class GalloryHGTop extends StatefulWidget {
  final catTimeID;
  final String imgPath;
  final String fileName;
  const GalloryHGTop({Key key, this.imgPath, this.fileName, this.catTimeID})
      : super(key: key);

  @override
  _GalloryHGTopState createState() => _GalloryHGTopState();
}

class _GalloryHGTopState extends State<GalloryHGTop> {
  bool showState = false;
  CatTimeHelper catTimeHelper;
  Future<CatTimeModel> catTimeData;
  ImageNavidation line = new ImageNavidation();

  Future loadData() async {
    catTimeData = catTimeHelper.getCatTimeWithCatTimeID(widget.catTimeID);
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
            title: Text("[2/2] ระบุความยาวรอบอกโค",
                style: TextStyle(
                    fontSize: 24,
                    color: Color(hex.hexColor("ffffff")),
                    fontWeight: FontWeight.bold)),
            backgroundColor: Color(hex.hexColor("#007BA4"))),
        body: new Stack(
          children: [
            LaPGalloryHGTop(
              imgPath: widget.imgPath,
              fileName: widget.fileName,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: FutureBuilder(
                  future: catTimeData,
                  builder: (context, AsyncSnapshot<CatTimeModel> snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MainButton(
                                  onSelected: () async {
                                    double hlt = calculate.distance(
                                        snapshot.data.pixelReference,
                                        snapshot.data.distanceReference,
                                        pos.getPixelDistance());

                                    double newHG = calculate.calHeartGirth(
                                        hlt, snapshot.data.hearLenghtRear);

                                    double weight = calculate.calWeight(
                                        snapshot.data.bodyLenght, newHG);

                                    // print("Hear Lenght Top: $hlt CM.\tCattle Weight: $weight Kg.");

                                    await catTimeHelper.updateCatTime(
                                        CatTimeModel(
                                            id: snapshot.data.id,
                                            idPro: snapshot.data.idPro,
                                            weight: weight,
                                            bodyLenght:
                                                snapshot.data.bodyLenght,
                                            heartGirth:
                                                newHG,
                                            hearLenghtSide:
                                                snapshot.data.hearLenghtSide,
                                            hearLenghtRear:
                                                snapshot.data.hearLenghtRear,
                                            hearLenghtTop: hlt,
                                            pixelReference:
                                                snapshot.data.pixelReference,
                                            distanceReference:
                                                snapshot.data.distanceReference,
                                            imageSide: snapshot.data.imageSide,
                                            imageRear: snapshot.data.imageRear,
                                            imageTop: snapshot.data.imageTop,
                                            date: snapshot.data.date,
                                            note: snapshot.data.note));

                                    // Navigator.pushAndRemoveUntil จะไม่สามารถย้อนกลับมายัง Screen เดิมได้
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CattleProfilPage(
                                                  catProID: snapshot.data.idPro,
                                                )),
                                        (route) => false);
                                  },
                                  title: "บันทึก"),
                            ]),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
            showState
                ? Container()
                : AlertDialog(
                    // backgroundColor: Colors.black,
                    title: Text("กรุณาระบุความยาวรอบอกโค",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    content:
                        Image.asset("assets/images/TopLeftNavigation4.png"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() => showState = !showState);
                        },
                        // => Navigator.pop(context, 'ตกลง'),
                        child:
                            const Text('ตกลง', style: TextStyle(fontSize: 24)),
                      ),
                    ],
                  ),
          ],
        ));
  }
}

class LaPGalloryHGTop extends StatefulWidget {
  final String imgPath;
  final String fileName;
  final VoidCallback onSelected;
  const LaPGalloryHGTop(
      {this.imgPath, this.fileName, this.onSelected});

  @override
  LaPGalloryHGTopState createState() =>
      new LaPGalloryHGTopState();
}

class LaPGalloryHGTopState
    extends State<LaPGalloryHGTop> {
  List<double> positionsX = [];
  List<double> positionsY = [];
  double pixelDistance = 0;
  int index = 0;

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    setState(() {
      index++;
      positionsX.add(localOffset.dx);
      positionsY.add(localOffset.dy);
      // Distance calculation
      positionsX.length % 2 == 0
          ? pixelDistance = calculate.pixelDistance(positionsX[index - 1],
              positionsY[index - 1], positionsX[index], positionsY[index])
          : pixelDistance = pixelDistance;

      // print("Pixel Distance = ${pixelDistance}");
      pos.setPixelDistance(pixelDistance);
      print("POS  = ${pos.getPixelDistance()}");
    });
  }

  @override
  void initState() {
    super.initState();
    positionsX.add(100);
    positionsY.add(100);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: (TapDownDetails details) => onTapDown(context, details),
      child: new Stack(fit: StackFit.loose, children: <Widget>[
        // Hack to expand stack to fill all the space. There must be a better
        // way to do it.
        // new Container(color: Colors.white),
        new RotatedBox(
          quarterTurns: 1,
          child: PreviewScreen(
            imgPath: widget.imgPath,
            fileName: widget.fileName,
          ),
        ),
        //// Show position (x2,y2)
        // new Positioned(
        //   child: new Text(
        //       '(${positionsX[index].toInt()} , ${positionsY[index].toInt()})'),
        //   left: positionsX[index],
        //   top: positionsY[index],
        // ),
        //// Show position (x1,y1)
        // positionsX.length % 2 == 0
        //     ? new Positioned(
        //         child: new Text(
        //             '(${positionsX[index - 1].toInt()} , ${positionsY[index - 1].toInt()})'),
        //         left: positionsX[index - 1],
        //         top: positionsY[index - 1],
        //       )
        //     : Container(),
        // // Distance calculation
        // positionsX.length % 2 == 0
        //     ? Text(
        //         "${sqrt(((positionsX[index] - positionsX[index - 1]) * (positionsX[index] - positionsX[index - 1])) + ((positionsY[index] - positionsY[index - 1]) * (positionsY[index] - positionsY[index - 1])))}")
        //     : Container(),
        PathCircle(
          x1: positionsX[index],
          y1: positionsY[index],
        ),
        positionsX.length % 2 == 0
            ? PathCircle(
                x1: positionsX[index - 1],
                y1: positionsY[index - 1],
              )
            : Container(),
        positionsX.length % 2 == 0
            ? new PathExample(
                x1: positionsX[index - 1],
                y1: positionsY[index - 1],
                x2: positionsX[index],
                y2: positionsY[index],
              )
            : Container(),

        // Padding(
        //   padding: EdgeInsets.all(20),
        //   child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        //     MainButton(
        //         onSelected: () {
        //           widget.onSelected();
        //         },
        //         title: "บันทึก"),
        //   ]),
        // ),
      ]),
    );
  }
}
