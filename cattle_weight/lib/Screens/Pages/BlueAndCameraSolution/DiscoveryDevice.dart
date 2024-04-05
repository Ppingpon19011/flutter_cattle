import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cattle_weight/Camera/cameraSide_screen.dart';
import 'package:cattle_weight/Screens/Widgets/MainButton.dart';
import 'package:cattle_weight/model/imageNavidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sqflite/utils/utils.dart';

import 'package:cattle_weight/Bluetooth/BluetoothDeviceListEntry.dart';
import 'package:cattle_weight/Bluetooth/ChatPage.dart';
import 'package:cattle_weight/Screens/Widgets/blueAndCameraSide.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:cattle_weight/model/catTime.dart';

// ConvertHex convert color code from web
ConvertHex hex = new ConvertHex();
ImageNavidation line = new ImageNavidation();

class DiscoveryPage extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;
  final int idPro;
  final int idTime;
  final CatTimeModel catTime;
  // final CameraDescription camera;

  const DiscoveryPage({
    Key? key,
    required this.start,
    required this.idPro,
    required this.idTime,
    required this.catTime,
  }) : super(key: key);

  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  late StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = [];
  late bool isDiscovering;

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        results.add(r);
      });
    });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(hex.hexColor("#47B5BE")),
        title: isDiscovering
            ? Text('Discovering devices')
            : Text('Discovered devices'),
        actions: <Widget>[
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: new EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, index) {
            BluetoothDiscoveryResult result = results[index];
            return BluetoothDeviceListEntry(
              device: result.device,
              rssi: result.rssi,
              onTap: () {
                Navigator.of(context).pop(result.device);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlueAndCameraSide(
                        server: result.device,
                        idPro: widget.idPro,
                        idTime: widget.idTime,
                        catTime: widget.catTime
                        // camera: widget.camera,
                        )));
              },
            );
          },
        ),
      ]),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      //   child: Container(
      //       width: double.infinity,
      //       height: 56,
      //       child: MainButton(
      //           onSelected: () {
      //             Navigator.of(context).push(MaterialPageRoute(
      //                 builder: (context) => CameraSideScreen(
      //                       idPro: widget.idPro,
      //                       idTime: widget.idTime,
      //                       localFront: line.sideLeft,
      //                       localBack: line.sideRight,
      //                       catTime: widget.catTime,
      //                     )));
      //           },
      //           title: "ไม่เชื่อมต่ออุปกรณ์"),
      //     ),
      // ),
    );
  }
}
