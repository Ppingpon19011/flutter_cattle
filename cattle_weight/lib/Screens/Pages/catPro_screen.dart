import 'package:cattle_weight/DataBase/catImage_handler.dart';
import 'package:cattle_weight/DataBase/catPro_handler.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/ProfilePage.dart';
import 'package:cattle_weight/Screens/Widgets/catProCard.dart';
import 'package:cattle_weight/model/catPro.dart';
import 'package:cattle_weight/Screens/Pages/catPro_Create.dart';
import 'package:cattle_weight/Screens/Pages/catPro_Edit.dart';
import 'package:cattle_weight/Screens/Pages/catTime_screen.dart';
import 'package:cattle_weight/model/catTime.dart';
import 'package:cattle_weight/model/utility.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'dart:io' as io;

class CatProExportCsv {
  final List<CatProModel> catProData;
  CatProExportCsv({required this.catProData});

  List<List<dynamic>> rows = <List<dynamic>>[];
  downloadData() async {
    List<dynamic> Colum = [
      "Cattle ID",
      "Cattle name",
      "Gender",
      "Speciese",
    ];
    rows.add(Colum);
    for (int i = 0; i < catProData.length; i++) {
      List<dynamic> row = [];
      row.add(catProData[i].id);
      row.add(catProData[i].name.toString());
      row.add(catProData[i].gender);
      row.add(catProData[i].species);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);
    // new AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
    //   ..setAttribute("download", "data.csv")
    //   ..click();
    final String dir = "/storage/emulated/0/Documents";
    final String path =
        '$dir/CattleList_${DateTime.now().toIso8601String()}.csv';

    // create file
    final io.File file = io.File(path);
    // Save csv string using default configuration
    // , as field separator
    // " as text delimiter and
    // \r\n as eol.
    await file.writeAsString(csv);
  }
}

class CatProScreen extends StatefulWidget {
  const CatProScreen({Key? key}) : super(key: key);

  @override
  _CatProScreenState createState() => _CatProScreenState();
}

class _CatProScreenState extends State<CatProScreen> {
  CatProHelper? dbHelper;
  CatTimeHelper? dbCatTime;
  CatImageHelper? dbImage;
  late Future<List<CatProModel>> catProList;
  late Future<CatTimeModel> catTimeTop;
// search
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');

  // This is what you select from the action sheet
  String? _selectedOption;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = CatProHelper();
    dbCatTime = CatTimeHelper();
    dbImage =CatImageHelper();
    loadData();
    setState(() {});
  }

  loadData() async {
    catProList = dbHelper!.getCatProList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("หน้าหลัก",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            //  IconButton(
            //     onPressed: () {
            //       // setState(() {
            //       //   loadData();
            //       // });
            //     },
            //     icon: Icon(Icons.save)),
            IconButton(
                onPressed: () {
                  setState(() {
                    loadData();
                  });
                },
                icon: const Icon(Icons.refresh)),
          ]),
      body: FutureBuilder(
          future: catProList,
          builder: (context, AsyncSnapshot<List<CatProModel>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                color: Colors.grey.shade200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InkWell(
                                onTap: () {
                                  showSearch(
                                    context: context,
                                    delegate: SearchPage<CatProModel>(
                                      onQueryUpdate: (s) => print(s),
                                      items: snapshot.data!,
                                      searchLabel: 'ค้นหา',
                                      suggestion: Center(
                                          child: ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          final CatProModel catPro =
                                              snapshot.data![index];
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CattleProfilPage(
                                                            catProID:
                                                                catPro.id!,
                                                          )));
                                            },
                                            child: ListTile(
                                              title: Text(catPro.name,
                                                  style: const TextStyle(
                                                      fontSize: 24)),
                                              subtitle: Text(catPro.gender,
                                                  style: const TextStyle(
                                                      fontSize: 18)),
                                              trailing: Text(catPro.species,
                                                  style: const TextStyle(
                                                      fontSize: 18)),
                                            ),
                                          );
                                        },
                                      )),
                                      failure: const Center(
                                        child: Text(
                                            'ไม่พบข้อมูล กรุณาค้นหาใหม่',
                                            style: TextStyle(fontSize: 24)),
                                      ),
                                      filter: (catProData) => [
                                        catProData.name,
                                        catProData.gender,
                                        catProData.species,
                                      ],
                                      builder: (catProData) => InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CattleProfilPage(
                                                        catProID:
                                                            catProData.id!,
                                                      )));
                                        },
                                        child: ListTile(
                                          title: Text(catProData.name,
                                              style: const TextStyle(
                                                  fontSize: 24)),
                                          subtitle: Text(catProData.gender,
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                          trailing: Text(catProData.species,
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      new Icon(Icons.search),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const Text("ค้นหา",
                                          style: TextStyle(fontSize: 20))
                                    ],
                                  ),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            reverse: false,
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              catTimeTop = dbCatTime!.getCatTimeWithCatPro(
                                  snapshot.data![index].id!);

                              return CatProCard(
                                  catTimeTop: catTimeTop,
                                  catPro: snapshot.data![index],
                                  onDelete: () {
                                    setState(() {
                                      // delete row in catpro table with snapshot.data![index].id!
                                      dbHelper!.deleteCatPro(
                                          snapshot.data![index].id!);

                                      // delete row in cattime table with snapshot.data![index].id!
                                      dbCatTime!.deleteCatTimeWithIdPro(
                                          snapshot.data![index].id!);

                                      // delete cattle Image in images table
                                      dbImage!.deleteWithIDPro(
                                          snapshot.data![index].id!);

                                      catProList = dbHelper!.getCatProList();
                                    });
                                  });
                            })),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CatProFormCreate()));
          },
          child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
