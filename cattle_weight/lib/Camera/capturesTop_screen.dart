import 'dart:io';

import 'package:cattle_weight/Camera/previewTop_screen.dart';
import 'package:flutter/material.dart';

import 'package:cattle_weight/model/catTime.dart';

import '../Camera/previewSide_screen.dart';

class CapturesTopScreen extends StatefulWidget {
  final int idPro;
  final int idTime;
  final List<File> imageFileList;
  final CatTimeModel catTime;
  const CapturesTopScreen({
    Key? key,
    required this.idPro,
    required this.idTime,
    required this.imageFileList,
    required this.catTime,
  }) : super(key: key);

  @override
  State<CapturesTopScreen> createState() => _CapturesTopScreenState();
}

class _CapturesTopScreenState extends State<CapturesTopScreen> {
  
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
                            builder: (context) => PreviewTopScreen(
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
