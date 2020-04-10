import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outfitter/components/Uploader.dart';
import 'dart:io';
import 'dart:async';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ImageCapture(),
    );
  }
}

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  // Active image file
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  // Remove image
  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  //Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        // ratioX:1.0,
        // ratioY:1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.amber,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _imageFile = cropped ?? _imageFile; // this returns existing first file
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
       child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery)),
            ],
          ),
      ),
      body: ListView(
            children: <Widget>[
              if(_imageFile != null) ...[
                // ignore: sdk_version_ui_as_code, sdk_version_ui_as_code
                Image.file(_imageFile),
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: ()=> _cropImage(), child: Icon(Icons.crop)),
                    FlatButton(onPressed: ()=> _clear, child: Icon(Icons.refresh)),
                  ],
                ),

                Uploader(file: _imageFile)
              ]
            ],
          ),
      );
  }
}
