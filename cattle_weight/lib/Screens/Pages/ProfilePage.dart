import 'package:camera/camera.dart';
import 'package:cattle_weight/DataBase/catPro_handler.dart';
import 'package:cattle_weight/Screens/Pages/catTime_screen.dart';
import 'package:cattle_weight/model/catPro.dart';
import 'package:flutter/material.dart';

import 'package:cattle_weight/DataBase/CattleDB.dart';
import 'package:cattle_weight/DataBase/ProfileDB.dart';
import 'package:cattle_weight/Screens/Widgets/CattleBox.dart';
import 'package:cattle_weight/Screens/Widgets/ProfileBox.dart';
import 'package:cattle_weight/convetHex.dart';

import 'ChartPage.dart';

ConvertHex hex = new ConvertHex();

class CattleProfilPage extends StatefulWidget {
  const CattleProfilPage({
    Key? key,
    required this.catProID,
  }) : super(key: key);

  final int catProID;

  @override
  _CattleProfilPageState createState() => _CattleProfilPageState();
}

class _CattleProfilPageState extends State<CattleProfilPage> {
  CatProHelper? catProHelper;

  late Future<CatProModel> catProData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    catProHelper = new CatProHelper();

    loadData();
    // NotesModel(title: "User00",age: 22,description: "Default user",email: "User@exemple.com");
  }

  loadData() async {
    catProData = catProHelper!.getCatProWithID(widget.catProID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: catProData,
        builder: (context, AsyncSnapshot<CatProModel> catPro) {
          if (catPro.hasData) {
            return DefaultTabController(
              ///จำนวนเมนู
              length: 2,
              child: Scaffold(
                backgroundColor: Color(hex.hexColor('#FFC909')),

                ///กำหนดให้แต่ละ tapBar แสดงอะไร
                body: TabBarView(
                  children: [
                    // หน้าแอปที่ต้องการให้ทำงานเมื่อกดเมนู
                    CatTimeScreen(
                      catProID: widget.catProID,
                    ),
                    ChartCattle(
                        title: catPro.data!.name, catProID: catPro.data!.id!),
                  ],
                ),
                bottomNavigationBar: TabBar(
                  tabs: [
                    // ตั้งค่าเมนูภายใน  TapBar View
                    Tab(
                        icon: Icon(
                      Icons.list,
                      size: 48,
                    )),
                    Tab(
                      icon: Icon(
                        Icons.bar_chart_rounded,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
