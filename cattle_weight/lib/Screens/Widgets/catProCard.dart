import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cattle_weight/DataBase/catImage_handler.dart';
import 'package:cattle_weight/DataBase/catPro_handler.dart';
import 'package:cattle_weight/DataBase/catTime_handler.dart';
import 'package:cattle_weight/Screens/Pages/ProfilePage.dart';
import 'package:cattle_weight/Screens/Pages/catPro_Edit.dart';
import 'package:cattle_weight/model/catPro.dart';
import 'package:cattle_weight/model/catTime.dart';
import 'package:cattle_weight/model/utility.dart';

class CatProCard extends StatefulWidget {
  final Future<CatTimeModel> catTimeTop;
  final CatProModel catPro;
  final Function onDelete;
  const CatProCard({
    Key? key,
    required this.catTimeTop,
    required this.catPro,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CatProCard> createState() => _CatProCardState();
}

class _CatProCardState extends State<CatProCard> {
  CatProHelper? dbHelper;
  CatTimeHelper? dbCatTime;
  CatImageHelper? dbImage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.catTimeTop,
        builder: (context, AsyncSnapshot<CatTimeModel> cattime) {
          void _close(BuildContext ctx) {
            Navigator.of(ctx).pop();
          }

          void _show(BuildContext ctx) {
            showCupertinoModalPopup(
                context: ctx,
                builder: (_) => CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CatProFormEdit(catPro: widget.catPro)));
                              });
                              // _close(ctx);
                            },
                            child: const Text('แก้ไข')),
                        CupertinoActionSheetAction(
                            onPressed: () {
                              // setState(() {
                              //   onDelete();
                              // });

                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        "ลบข้อมูล ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: const Text(
                                        'คุณต้องการลบข้อมูลโคหรือไม่',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => _close(ctx),
                                          child: const Text(
                                            'ยกเลิก',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            widget.onDelete();
                                            _close(ctx);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'ตกลง',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Text('ลบ')),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () => _close(ctx),
                        child: const Text('ยกเลิก'),
                      ),
                    ));
          }

          // This function is used to close the action sheet

          if (cattime.hasData) {
            DateTime catTimeDate = DateTime.parse(cattime.data!.date);
            String convertedDateTime =
                "${catTimeDate.day.toString().padLeft(2, '0')}/${catTimeDate.month.toString().padLeft(2, '0')}/${catTimeDate.year.toString()} เวลา: ${catTimeDate.hour.toString().padLeft(2, '0')}.${catTimeDate.minute.toString().padLeft(2, '0')}";
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CattleProfilPage(catProID: widget.catPro.id!)));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 8,
                  shadowColor: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: 
                       ((cattime.data!.imageSide == null) ||
                              (cattime.data!.imageSide == ''))
                          ? RotatedBox(
                              quarterTurns: 0,
                              child: Image.asset(
                                "assets/images/SideLeftNavigation2.png",
                                height: 240,
                                width: 360,
                              ),
                            )
                          : RotatedBox(
                              quarterTurns: -1,
                              child: Utility.imageFromBase64String(
                                  cattime.data!.imageSide),
                            ),
                      subtitle: ListTile(
                        title: Text(widget.catPro.name.toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            "สายพันธ์ุ: ${widget.catPro.species.toString()}\nเพศ: ${widget.catPro.gender.toString()}\nน้ำหนัก: ${cattime.data!.weight.toStringAsFixed(0)} Kg",
                            style: const TextStyle(fontSize: 18)),
                        trailing: IconButton(
                            onPressed: () {
                              _show(context);
                            },
                            icon: const Icon(Icons.menu)),
                      )),
                ),
              ),
            );
          } else {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CattleProfilPage(catProID: widget.catPro.id!)));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PhysicalModel(
                  color: Colors.white,
                  elevation: 8,
                  shadowColor: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      // title:
                      // RotatedBox(
                      //   quarterTurns: 0,
                      //   child: Image.asset(
                      //     "assets/images/SideLeftNavigation2.png",
                      //     height: 240,
                      //     width: 360,
                      //   ),
                      // ),
                      subtitle: ListTile(
                        title: Text(widget.catPro.name.toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            "Gender: ${widget.catPro.gender.toString()}\nSpecies: ${widget.catPro.species.toString()}",
                            style: const TextStyle(fontSize: 18)),
                        trailing: IconButton(
                            onPressed: () {
                              _show(context);
                            },
                            icon: const Icon(Icons.menu)),
                      )),
                ),
              ),
            );
          }
        });
  }
}
