
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cattle_weight/Camera/cameraRear_screen.dart';
import 'package:cattle_weight/DataBase/catImage_handler.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/GallorySolutions/PictureRefRear.dart';
import 'package:cattle_weight/Screens/Widgets/LineAndPosition.dart';
import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:cattle_weight/Screens/Widgets/PaintLine.dart';
import 'package:cattle_weight/Screens/Widgets/PaintPoint.dart';

import 'package:cattle_weight/Screens/Widgets/position.dart';
import 'package:cattle_weight/Screens/Widgets/preview.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:cattle_weight/model/calculation.dart';
import 'package:cattle_weight/model/catTime.dart';
import 'package:cattle_weight/model/image.dart';
import 'package:cattle_weight/model/imageNavidation.dart';
import 'package:cattle_weight/model/utility.dart';
import 'package:flutter/material.dart';

import 'dart:ffi';
import 'dart:math';

import 'package:image_picker/image_picker.dart';

ConvertHex hex = new ConvertHex();
Positions pos = new Positions();
CattleCalculation calculate = new CattleCalculation();

class GalloryBL extends StatefulWidget {
  final int? catTimeID;
  final String? imgPath;
  final String? fileName;
  const GalloryBL({Key? key, this.imgPath, this.fileName, this.catTimeID})
      : super(key: key);

  @override
  _GalloryBLState createState() => _GalloryBLState();
}

class _GalloryBLState extends State<GalloryBL> {
  bool showState = false;
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
            title: Text("[3/3] กรุณาระบุความยาวลำตัวโค",
                style: TextStyle(
                    fontSize: 24,
                    color: Color(hex.hexColor("ffffff")),
                    fontWeight: FontWeight.bold)),
            backgroundColor: Color(hex.hexColor("#007BA4"))),
        body: new Stack(
          children: [
            LaPGalloryBL(
              imgPath: widget.imgPath!,
              fileName: widget.fileName!,
            ),
            Padding(
              padding: EdgeInsets.all(20),
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

                          double bl = calculate.distance(
                              snapshot.data!.pixelReference,
                              snapshot.data!.distanceReference,
                              pos.getPixelDistance());

                          print("Body Lenght: $bl CM.");

                          catTimeHelper.updateCatTime(CatTimeModel(
                              id: snapshot.data!.id,
                              idPro: snapshot.data!.idPro,
                              weight: snapshot.data!.weight,
                              bodyLenght: bl,
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
                              date: snapshot.data!.date,
                              note: snapshot.data!.note));

                          setState(() {
                            refreshImages();
                          });

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GalloryRefRear(
                                  imageFile: file,
                                  fileName: file.path,
                                  catTimeID: snapshot.data!.id!)));
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
                      return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MainButton(
                                  onSelected: () async {
                                    GalloryImage();
                                  },
                                  title: "บันทึก", pixelDistance: 10,),
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
                    title: Text("กรุณาระบุความยาวลำตัวโค",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    content:
                        Image.asset("assets/images/SideLeftNavigation4.png"),
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

class LaPGalloryBL extends StatefulWidget {
  final String? imgPath;
  final String? fileName;
  final VoidCallback? onSelected;
  const LaPGalloryBL({this.imgPath, this.fileName, this.onSelected});

  @override
  LaPGalloryBLState createState() => new LaPGalloryBLState();
}

class LaPGalloryBLState extends State<LaPGalloryBL> {
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
