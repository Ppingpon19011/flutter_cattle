

import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:cattle_weight/Bluetooth/BlueMassgae.dart';
import 'package:cattle_weight/Screens/Pages/BlueAndCameraSolution/BluePictureHG.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/CameraSolutions/PictureHG.dart';
import 'package:cattle_weight/Screens/Widgets/LineAndPosition.dart';
import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:cattle_weight/Screens/Widgets/PaintLine.dart';
import 'package:cattle_weight/Screens/Widgets/PaintPoint.dart';
import 'package:cattle_weight/Screens/Widgets/position.dart';
import 'package:cattle_weight/Screens/Widgets/preview.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:cattle_weight/model/calculation.dart';
import 'package:cattle_weight/model/catTime.dart';

ConvertHex hex = new ConvertHex();
Positions pos = new Positions();
CattleCalculation calculate = new CattleCalculation();

class BluePictureRefSide extends StatefulWidget {
  final File? imageFile;
  final String? fileName;
  final CatTimeModel? catTime;
  final BluetoothDevice? server;
  final bool? blueConnection;

  const BluePictureRefSide({
    Key? key,
    this.imageFile,
    this.fileName,
    this.catTime,
    this.server,
    this.blueConnection,
  }) : super(key: key);

  @override
  _BluePictureRefSideState createState() => _BluePictureRefSideState();
}

class _BluePictureRefSideState extends State<BluePictureRefSide> {
  bool showState = false;
  final TextEditingController _textFieldController = TextEditingController();
  late CatTimeHelper catTimeHelper;
  late Future<CatTimeModel> catTimeData;

  loadData() async {
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
    return FutureBuilder(
        future: catTimeData,
        builder: (context, AsyncSnapshot<CatTimeModel> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                    title: Text("[1/3] กรุณาระบุจุดอ้างอิง",
                        style: TextStyle(
                            fontSize: 24,
                            color: Color(hex.hexColor("ffffff")),
                            fontWeight: FontWeight.bold)),
                    backgroundColor: Color(hex.hexColor("#007BA4"))),
                body: Stack(
                  children: [
                    LineAndPositionPictureRef(
                        imgPath: widget.imageFile!.path,
                        fileName: widget.fileName!),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MainButton(
                                  onSelected: () async {
                                    // print("height: ${snapshot.data.distanceReference}");

                                    await catTimeHelper.updateCatTime(
                                        CatTimeModel(
                                            id: snapshot.data!.id,
                                            idPro: snapshot.data!.idPro,
                                            weight: snapshot.data!.weight,
                                            bodyLenght:
                                                snapshot.data!.bodyLenght,
                                            heartGirth:
                                                snapshot.data!.heartGirth,
                                            hearLenghtSide:
                                                snapshot.data!.hearLenghtSide,
                                            hearLenghtRear:
                                                snapshot.data!.hearLenghtRear,
                                            hearLenghtTop:
                                                snapshot.data!.hearLenghtTop,
                                            pixelReference:
                                                pos.getPixelDistance(),
                                            distanceReference:
                                                snapshot.data!.distanceReference,
                                            imageSide: snapshot.data!.imageSide,
                                            imageRear: snapshot.data!.imageRear,
                                            imageTop: snapshot.data!.imageTop,
                                            date: DateTime.now()
                                                .toIso8601String(),
                                            note: snapshot.data!.note));

                                    loadData();
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => BluePictureHG(
                                                  imageFile: widget.imageFile,
                                                  fileName: widget.fileName,
                                                  catTime: widget.catTime,
                                                  server: widget.server,
                                                  blueConnection:
                                                      widget.blueConnection,
                                                )));
                                  },
                                  title: "บันทึก", pixelDistance: 10,),
                            ]),
                      ),
                    ),
                    showState
                        ? Container()
                        : AlertDialog(
                            // backgroundColor: Colors.black,
                            title: Text("กรุณาระบุจุดอ้างอิง",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                            content: Image.asset(
                                "assets/images/SideLeftNavigation5.png"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() => showState = !showState);
                                },
                                // => Navigator.pop(context, 'ตกลง'),
                                child: const Text('ตกลง',
                                    style: TextStyle(fontSize: 24)),
                              ),
                            ],
                          ),
                  ],
                ));
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            );
          }
        });
  }
}

class LineAndPositionPictureRef extends StatefulWidget {
  final String? imgPath;
  final String? fileName;
  final VoidCallback? onSelected;
  const LineAndPositionPictureRef(
      {this.imgPath, this.fileName, this.onSelected});

  @override
  LineAndPositionPictureRefState createState() =>
      new LineAndPositionPictureRefState();
}

class LineAndPositionPictureRefState extends State<LineAndPositionPictureRef> {
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
          ? pixelDistance = calculate.pixelDistance(positionsX[index - 1],
              positionsY[index - 1], positionsX[index], positionsY[index])
          // pixelDistance = sqrt(((positionsX[index] - positionsX[index - 1]) *
          //         (positionsX[index] - positionsX[index - 1])) +
          //     ((positionsY[index] - positionsY[index - 1]) *
          //         (positionsY[index] - positionsY[index - 1])))
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
