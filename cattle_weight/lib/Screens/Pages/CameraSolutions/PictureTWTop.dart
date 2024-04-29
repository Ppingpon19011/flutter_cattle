
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:cattle_weight/Screens/Pages/CameraSolutions/PictureHGTop.dart';
import 'package:cattle_weight/model/calculation.dart';
import 'package:flutter/material.dart';

import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/CameraSolutions/PictureHG.dart';
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
CattleCalculation calculate = new CattleCalculation();

class PictureTWTop extends StatefulWidget {
  final File? imageFile;
  final String? fileName;
  final CatTimeModel? catTime;
  const PictureTWTop({
    Key? key,
    this.imageFile,
    this.fileName,
    this.catTime,
  }) : super(key: key);

  @override
  _PictureTWTopState createState() => _PictureTWTopState();
}

class _PictureTWTopState extends State<PictureTWTop> {
  bool showState = false;
  TextEditingController _textFieldController = TextEditingController();
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
    return Scaffold(
        appBar: AppBar(
            title: Text("[1/2] กรุณาระบุความกว้างกระดูกก้นกบของโค",
                style: TextStyle(
                    fontSize: 24,
                    color: Color(hex.hexColor("ffffff")),
                    fontWeight: FontWeight.bold)),
            backgroundColor: Color(hex.hexColor("#007BA4"))),
        body: FutureBuilder(
            future: catTimeData,
            builder: (context, AsyncSnapshot<CatTimeModel> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    LineAndPositionPictureTWTop(
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
                                    // print("POS: ${pos.getPixelDistance().toStringAsFixed(4)}\tHear Lenght Rear: ${snapshot.data.hearLenghtRear.toStringAsFixed(4)}");

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
                                                snapshot.data!.hearLenghtRear,
                                            imageSide: snapshot.data!.imageSide,
                                            imageRear: snapshot.data!.imageRear,
                                            imageTop: snapshot.data!.imageTop,
                                            date: DateTime.now()
                                                .toIso8601String(),
                                            note: snapshot.data!.note));

                                    loadData();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => PictureHGTop(
                                                imgPath: widget.imageFile!.path,
                                                fileName: widget.fileName,
                                                catTimeID: snapshot.data!.id)));
                                  },
                                  title: "บันทึก", pixelDistance: 10,),
                            ]),
                      ),
                    ),
                    showState
                        ? Container()
                        : AlertDialog(
                            // backgroundColor: Colors.black,
                            title: Text("ระบุความกว้างกระดูกก้นกบของโค",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                            content: Image.asset(
                                "assets/images/TopLeftNavigation3.png"),
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
                );
              } else {
                return Container();
              }
            }));
  }
}

class LineAndPositionPictureTWTop extends StatefulWidget {
  final String? imgPath;
  final String? fileName;
  final VoidCallback? onSelected;
  const LineAndPositionPictureTWTop(
      {this.imgPath, this.fileName, this.onSelected});

  @override
  LineAndPositionPictureTWTopState createState() =>
      new LineAndPositionPictureTWTopState();
}

class LineAndPositionPictureTWTopState
    extends State<LineAndPositionPictureTWTop> {
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
