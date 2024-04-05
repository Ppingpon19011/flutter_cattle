import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:cattle_weight/model/catTime.dart';

import '../Camera/previewSide_screen.dart';

class BlueCapturesSideScreen extends StatefulWidget {
  final int idPro;
  final int idTime;
  final List<File> imageFileList;
  final CatTimeModel catTime;
  final BluetoothDevice server;
  final bool blueConnection;
  final double heightValue;
  const BlueCapturesSideScreen({
    Key? key,
    required this.idPro,
    required this.idTime,
    required this.imageFileList,
    required this.catTime,
    required this.server,
    required this.blueConnection,
    required this.heightValue,
  }) : super(key: key);

  @override
  State<BlueCapturesSideScreen> createState() => _BlueCapturesSideScreenState();
}

class _BlueCapturesSideScreenState extends State<BlueCapturesSideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Captures',
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.white,
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: [
                for (File imageFile in widget.imageFileList)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => PreviewSideScreen(
                              idPro: widget.idPro,
                              idTime: widget.idTime,
                              fileList: widget.imageFileList,
                              imageFile: imageFile,
                              catTime: widget.catTime,
                            ),
                          ),
                        );
                      },
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
