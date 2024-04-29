
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/CameraSolutions/PictureBL.dart';
import 'package:cattle_weight/Screens/Widgets/LineAndPosition.dart';
import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:cattle_weight/Screens/Widgets/PaintLine.dart';
import 'package:cattle_weight/Screens/Widgets/PaintPoint.dart';
import 'package:cattle_weight/Screens/Widgets/position.dart';
import 'package:cattle_weight/Screens/Widgets/preview.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:cattle_weight/model/catTime.dart';

ConvertHex hex = new ConvertHex();
Positions pos = new Positions();

class PictureHG extends StatefulWidget {
  // final bool blueConnection;
  // final CameraDescription camera;
  final File? imageFile;
  final String? fileName;
  final CatTimeModel? catTime;
  const PictureHG({
    Key? key,
    this.imageFile,
    this.fileName,
    this.catTime,
  }) : super(key: key);

  @override
  _PictureHGState createState() => _PictureHGState();
}

class _PictureHGState extends State<PictureHG> {
  bool showState = false;
  late CatTimeHelper catTimeHelper;
  late Future<CatTimeModel> catTimeData;

  Future loadData() async {
    catTimeData = catTimeHelper.getCatTimeWithCatTimeID(widget.catTime!.id!);
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
            title: Text("[2/3] กรุณาระบุความยาวรอบอกโค",
                style: TextStyle(
                    fontSize: 24,
                    color: Color(hex.hexColor("ffffff")),
                    fontWeight: FontWeight.bold)),
            backgroundColor: Color(hex.hexColor("#007BA4"))),
        body: new Stack(
          children: [
            LineAndPositionPictureHG(
              imgPath: widget.imageFile!.path,
              fileName: widget.fileName!,
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
                                  // print(
                                  //     "Pixel Reference: ${snapshot.data.pixelReference}\tDistance Reference: ${snapshot.data.distanceReference}\nimageSide: ${snapshot.data.imageSide}");
                                  double hls = calculate.distance(
                                      snapshot.data!.pixelReference,
                                      snapshot.data!.distanceReference,
                                      pos.getPixelDistance());

                                  print("Hear Lenght Side: $hls CM.");
                                  
                                  await catTimeHelper.updateCatTime(
                                      CatTimeModel(
                                          id: snapshot.data!.id,
                                          idPro: snapshot.data!.idPro,
                                          weight: snapshot.data!.weight,
                                          bodyLenght: snapshot.data!.bodyLenght,
                                          heartGirth: snapshot.data!.heartGirth,
                                          hearLenghtSide: hls,
                                          hearLenghtRear: snapshot
                                              .data!.hearLenghtRear,
                                          hearLenghtTop: snapshot
                                              .data!.hearLenghtTop,
                                          pixelReference: snapshot
                                              .data!.pixelReference,
                                          distanceReference:
                                              snapshot.data!.distanceReference,
                                          imageSide: snapshot.data!.imageSide,
                                          imageRear: snapshot.data!.imageRear,
                                          imageTop: snapshot.data!.imageTop,
                                          date:
                                              DateTime.now().toIso8601String(),
                                          note: snapshot.data!.note));
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PictureBL(
                                        imgPath: widget.imageFile!.path,
                                        fileName: widget.fileName,
                                        catTimeID: snapshot.data!.id),
                                  ));
                                },
                                title: "บันทึก", pixelDistance: 10,)
                          ]),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            showState
                ? Container()
                : AlertDialog(
                    // backgroundColor: Colors.black,
                    title: Text("กรุณาระบุความยาวรอบอกโค",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    content:
                        Image.asset("assets/images/SideLeftNavigation3.png"),
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

class LineAndPositionPictureHG extends StatefulWidget {
  final String? imgPath;
  final String? fileName;
  final VoidCallback? onSelected;
  const LineAndPositionPictureHG(
      {this.imgPath, this.fileName, this.onSelected});

  @override
  LineAndPositionPictureHGState createState() =>
      new LineAndPositionPictureHGState();
}

class LineAndPositionPictureHGState extends State<LineAndPositionPictureHG> {
  List<double> positionsX = [];
  List<double> positionsY = [];
  double pixelDistance = 0;
  int index = 0;

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.globalPosition}');
    final RenderBox? box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box!.globalToLocal(details.globalPosition);

    setState(() {
      index++;
      positionsX.add(localOffset.dx);
      positionsY.add(localOffset.dy);
      // Distance calculation
      positionsX.length % 2 == 0
          ? pixelDistance = calculate.pixelDistance(positionsX[index - 1], positionsY[index - 1], positionsX[index], positionsY[index])
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
            imgPath: widget.imgPath!,
            fileName: widget.fileName!,
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
