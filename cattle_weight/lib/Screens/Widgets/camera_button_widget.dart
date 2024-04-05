import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cattle_weight/model/MediaSource.dart';

class CameraButtonWidget extends StatelessWidget {
  @override
 Widget build(BuildContext context){
    return Scaffold();
  }

  Future pickCameraMedia(BuildContext context) async {
    final  source = ModalRoute.of(context)!.settings.arguments as MediaSource;

    final getMedia = source == MediaSource.image
        ? ImagePicker().getImage
        : ImagePicker().getVideo;

    final media = await getMedia(source: ImageSource.camera);
    final file = File(media!.path);

    Navigator.of(context).pop(file);
  }
}
