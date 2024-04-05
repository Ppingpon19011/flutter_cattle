import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:cattle_weight/Screens/Widgets/CattleBox.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

// class ที่ใช้ในการแปลงค่าสีจากภายนอกมาใช้ใน flutter
ConvertHex hex = new ConvertHex();

class CattlePreview extends StatelessWidget {
  // final CameraDescription camera;
  final String cattleNumber;
  final String cattleName;
  final String gender;
  final String specise;
  final String img1;
  final String img2;
  final String img3;
  final double heartGirth;
  final double bodyLenght;
  final double weight;

  CattlePreview(
      this.cattleNumber,
      this.cattleName,
      this.gender,
      this.specise,
      this.img1,
      this.img2,
      this.img3,
      this.heartGirth,
      this.bodyLenght,
      this.weight,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cattleName,
          style: TextStyle(
            fontFamily: "boogaloo",
            fontSize: 24,
          ),
        ),
        backgroundColor: Color(hex.hexColor("#007BA4")),
        actions: [
          IconButton(
              onPressed: () {
                Phoenix.rebirth(context);
              },
              icon: Icon(Icons.home))
        ],
      ),
      body: ListView(children: [
        // นำภาพมาแสดงผล
        ImageSlideshow(
          width: double.infinity,
          height: 200,
          initialPage: 0,
          indicatorColor: Color(hex.hexColor("#FAA41B")),
          indicatorBackgroundColor: Colors.grey,
          children: [
            Image.asset(img1, fit: BoxFit.cover),
            Image.asset(img2, fit: BoxFit.cover),
            Image.asset(img3, fit: BoxFit.cover)
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(cattleName,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                      "Cattle number: ${cattleNumber} \t\t\t\tBody width : ${bodyLenght} \nSpecise : ${specise} \t\t\tHeart girth : ${heartGirth} \nGender : ${gender} \t\t\t\t\t\t\t\tWeight : ${weight}",
                      style: TextStyle(fontSize: 24, color: Colors.black))),
            ],
          ),
        )),
        SizedBox(
          height: 40,
        ),
        // ปุ่มแก้ไข
        Container(
            height: 50,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        height: 60,
                        width: 80,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: new RaisedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditOption()));
                            },
                            child: Text(
                              "แก้ไข",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(hex.hexColor("ffffff"))),
                            ),
                            color: Color(hex.hexColor("#FAA41B")),
                            // สีปุ่มเมื่อกด
                            splashColor: Color(hex.hexColor("#FFC909")),
                            // กำหนดรูปร่างของปุ่ม
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                              // side: BorderSide(color: Colors.black),
                            ),
                          ),
                        )),
                  ),
                  // ปุ่มลบ
                  Expanded(
                    child: Container(
                        height: 50,
                        width: 80,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: new RaisedButton(
                            onPressed: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("ลบข้อมูลของ $cattleName ",
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold)),
                                      content: Text(
                                          'คุณต้องการลบข้อมูลของ $cattleName ในวันที่ *02/01/2564* หรือไม่',
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.black)),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'ไม่ใช่'),
                                          child: const Text('ไม่ใช่',
                                              style: TextStyle(fontSize: 24)),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'ใช่'),
                                          child: const Text('ใช่',
                                              style: TextStyle(fontSize: 24)),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              "ลบ",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(hex.hexColor("ffffff"))),
                            ),
                            color: Color(hex.hexColor("#FAA41B")),
                            // สีปุ่มเมื่อกด
                            splashColor: Color(hex.hexColor("#FFC909")),
                            // กำหนดรูปร่างของปุ่ม
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                              // side: BorderSide(color: Colors.black),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 15,
        ),
        // ปุ่มบันทึกหน้าจอ
        Container(
            height: 50,
            width: 160,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: new RaisedButton(
                onPressed: () {
                  print("บันทึกหน้าจอ");
                },
                child: Text(
                  "บันทึกหน้าจอ",
                  style: TextStyle(
                      fontSize: 24, color: Color(hex.hexColor("ffffff"))),
                ),
                color: Color(hex.hexColor("#FAA41B")),
                // สีปุ่มเมื่อกด
                splashColor: Color(hex.hexColor("#FFC909")),
                // กำหนดรูปร่างของปุ่ม
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  // side: BorderSide(color: Colors.black),
                ),
              ),
            )),
        SizedBox(
          height: 15,
        ),
        // ปุ่มบันทึกหน้าจอ
        Container(
            height: 50,
            width: 160,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: new RaisedButton(
                onPressed: () {
                  // print("หน้าหลัก");
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(builder: (context) =>CattleHistory(camera: camera,)),
                  //     (route) => false);
                },
                child: Text(
                  "หน้าหลัก",
                  style: TextStyle(
                      fontSize: 24, color: Color(hex.hexColor("ffffff"))),
                ),
                color: Color(hex.hexColor("#FAA41B")),
                // สีปุ่มเมื่อกด
                splashColor: Color(hex.hexColor("#FFC909")),
                // กำหนดรูปร่างของปุ่ม
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  // side: BorderSide(color: Colors.black),
                ),
              ),
            )),
      ]),
    );
  }
}
