import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cattle_weight/convetHex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:cattle_weight/Bluetooth/BlueMassgae.dart';


// Messege Management
BleMessage BM = new BleMessage();
// ConvertHex convert color code from web
ConvertHex hex = new ConvertHex();

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;
  final CameraDescription camera;

  const ChatPage({
    Key? key,
    required this.server,
    required this.camera,
  }) : super(key: key);

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  var connection; //BluetoothConnection

  List<_Message> messages = [];
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool isDisconnecting = false;

  String formatedTime(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        getParsedTime(min.toString()) + " : " + getParsedTime(sec.toString());

    return parsedTime;
  }

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected()) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(hex.hexColor("#47B5BE")),
          title: (isConnecting
              ? Text('Connecting to  ${widget.server.name} ...',
                  style: TextStyle(fontSize: 24, fontFamily: 'boogaloo'))
              : isConnected()
                  ? Text('Device : ${widget.server.name}',
                      style: TextStyle(fontSize: 24, fontFamily: 'boogaloo'))
                  : Text('Device name : ${widget.server.name}',
                      style: TextStyle(fontSize: 24, fontFamily: 'boogaloo')))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrintBleMessage(
            message: BM.getMessage(),
          ),
          Container(
            height: 60,
            width: 240,
            child: ElevatedButton(
              onPressed: () {
                _disconnect();
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => SelectInput(widget.camera),
                // ));
              },
              child: Text("ยกเลิกการเชื่อมต่อ",
                  style: TextStyle(
                      fontSize: 24,
                      color: Color(hex.hexColor("ffffff")),
                      fontWeight: FontWeight.bold)),
              // color: Color(hex.hexColor("#47B5BE")),
              // shape: RoundedRectangleBorder(
              //   borderRadius: new BorderRadius.circular(20.0),
              //   side: BorderSide(color: Colors.white),
              // ),
            ),
          ),
          SizedBox(height:20),
          Container(
            height: 60,
            width: 240,
            child: ElevatedButton(
              onPressed: () {
                _connect();
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => SelectInput(widget.camera),
                // ));
              },
              child: Text("เชื่อมต่ออุปกรณ์",
                  style: TextStyle(
                      fontSize: 24,
                      color: Color(hex.hexColor("ffffff")),
                      fontWeight: FontWeight.bold)),
              // color: Color(hex.hexColor("#47B5BE")),
              // shape: RoundedRectangleBorder(
              //   borderRadius: new BorderRadius.circular(20.0),
              //   side: BorderSide(color: Colors.white),
              // ),
            ),
          )
        ],
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
        // Class  BleMessage = BM
        BM.setMessage(dataString.substring(0, index));
        BM.printMessage();
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  bool isConnected() {
    return connection != null && connection.isConnected;
  }

  void _connect() async {
    await BluetoothConnection.toAddress(widget.server.address)
        .then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  // Method to disconnect bluetooth
  void _disconnect() async {
    await connection.close();
    // show('Device disconnected');
    if (connection.isConnected) {
      setState(() {
        isDisconnecting = true;
        isConnecting = false;
      });
    }
  }
}

class PrintBleMessage extends StatefulWidget {
  final message;
  const PrintBleMessage({Key? key, this.message}) : super(key: key);

  @override
  _PrintBleMessageState createState() => _PrintBleMessageState();
}

class _PrintBleMessageState extends State<PrintBleMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 50),
      height: 350,
      width: 500,
      child: Center(
        child: Text(
          "Height = ${BM.getHeight()}\nDistance = ${BM.distance}\nAxisX = ${BM.axisY}\nAxisY = ${BM.axisY}\nAxisZ = ${BM.axisZ}",
          style: TextStyle(fontSize: 36),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
