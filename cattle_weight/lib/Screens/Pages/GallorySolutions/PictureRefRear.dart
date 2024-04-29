
import 'dart:io';
import 'dart:math';

import 'package:cattle_weight/Screens/Pages/CameraSolutions/PictureHG_Rear.dart';
import 'package:cattle_weight/Screens/Pages/GallorySolutions/PictureHgRear.dart';
import 'package:cattle_weight/model/calculation.dart';
import 'package:flutter/material.dart';

import 'package:cattle_weight/DataBase/catTime_handler.dart';
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

class GalloryRefRear extends StatefulWidget {
  final File? imageFile;
  final String? fileName;
  final int? catTimeID;
  const GalloryRefRear({
    Key? key,
    this.imageFile,
    this.fileName,
    this.catTimeID,
  }) : super(key: key);

  @override
  _GalloryRefRearState createState() => _GalloryRefRearState();
}

class _GalloryRefRearState extends State<GalloryRefRear> {
  bool showState = false;
  TextEditingController _textFieldController = TextEditingController();
  late CatTimeHelper catTimeHelper;
  late Future<CatTimeModel> catTimeData;

  loadData() async {
    catTimeData = catTimeHelper.getCatTimeWithCatTimeID(widget.catTimeID!);
  }

  @override
  void initState() {
    super.initState();
    catTimeHelper = new CatTimeHelper();

    loadData();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'ระบุความยาวของจุดอ้างอิง (เซนติเมตร)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            content: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 18),
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration:
                  InputDecoration(hintText: "กรุณาระบุความยาวของจุดอ้างอิง"),
            ),
            actions: <Widget>[
              FutureBuilder(
                  future: catTimeData,
                  builder: (context, AsyncSnapshot<CatTimeModel> snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 16),
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('ยกเลิก',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 16),
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                await catTimeHelper.updateCatTime(CatTimeModel(
                                    id: snapshot.data!.id,
                                    idPro: snapshot.data!.idPro,
                                    weight: snapshot.data!.weight,
                                    bodyLenght: snapshot.data!.bodyLenght,
                                    heartGirth: snapshot.data!.heartGirth,
                                    hearLenghtSide:
                                        snapshot.data!.hearLenghtSide,
                                    hearLenghtRear:
                                        snapshot.data!.hearLenghtRear,
                                    hearLenghtTop: snapshot.data!.hearLenghtTop,
                                    pixelReference: pos.getPixelDistance(),
                                    distanceReference:
                                        double.parse(_textFieldController.text),
                                    imageSide: snapshot.data!.imageSide,
                                    imageRear: snapshot.data!.imageRear,
                                    imageTop: snapshot.data!.imageTop,
                                    date: DateTime.now().toIso8601String(),
                                    note: snapshot.data!.note));

                                loadData();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => GalloryHG_Rear(
                                          imageFile: widget.imageFile,
                                          fileName: widget.fileName,
                                          catTime: snapshot.data,
                                        )));
                              },
                              child: const Text('บันทึก',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: Container(child: Text("กรุณาเปลี่ยนรูปด้านหลังโค",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),));
                    }
                  })
            ],
          );
        });
  }

  late String codeDialog;
  late String valueText;

  @override
  Widget build(BuildContext context) {
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
            LaPGalloryRefRear(
                imgPath: widget.imageFile!.path, fileName: widget.fileName!),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  MainButton(
                      onSelected: () async {
                     

                        _displayTextInputDialog(
                          context,
                        );
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
                    content:
                        Image.asset("assets/images/RearNavigation4.png"),
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

class LaPGalloryRefRear extends StatefulWidget {
  final String? imgPath;
  final String? fileName;
  final VoidCallback? onSelected;
  const LaPGalloryRefRear(
      {this.imgPath, this.fileName, this.onSelected});

  @override
  LaPGalloryRefRearState createState() =>
      new LaPGalloryRefRearState();
}

class LaPGalloryRefRearState extends State<LaPGalloryRefRear> {
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
