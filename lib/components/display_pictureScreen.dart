import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// enum for type
enum type4Cloth { top, pants, shoes }
// A widget that displays the picture taken by the user.
// ignore: must_be_immutable
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;

  type4Cloth _type = type4Cloth.top;

  Future<void> _uploadFile(context, type) async {
    final String uuid = Uuid().v1();
//    final Directory systemTempDir = Directory.systemTemp;
    final File file = await File(widget.imagePath).create();
    final StorageReference ref = storage.ref().child('photos').child(
        'photo-$uuid.png');
    final StorageUploadTask uploadTask = ref.putFile(
      file,
//      StorageMetadata(
//        contentLanguage: 'en',
//        customMetadata: <String, String>{'activity': 'test'},
//      ),
    );

    uploadTask.events.listen((e) async {
      if (e.type == StorageTaskEventType.success) {
        final String url = await ref.getDownloadURL();
        print("Download url: " + url);
        Navigator.pop(context, [url, _type]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
              child: Image.file(File(widget.imagePath)),
          ),
//          TextField(
//            controller: typeTextController,
//            obscureText: false,
//            decoration: InputDecoration(
//              border: OutlineInputBorder(),
//              labelText: 'Type',
//            ),
//          ),
          Expanded(
            flex: 1,
            child: RadioListTile<type4Cloth>(
              title: const Text('top'),
              value: type4Cloth.top,
              groupValue: _type,
              onChanged: (type4Cloth value) {
                setState(() {
                  _type = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: RadioListTile<type4Cloth>(
              title: const Text('pants'),
              value: type4Cloth.pants,
              groupValue: _type,
              onChanged: (type4Cloth value) {
                setState(() {
                  _type = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: RadioListTile<type4Cloth>(
              title: const Text('shoes'),
              value: type4Cloth.shoes,
              groupValue: _type,
              onChanged: (type4Cloth value) {
                setState(() {
                  _type = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  print(widget.imagePath);
                  _uploadFile(context, _type.toString());
                  print("type: " + _type.toString());
                },
                child: Text("Upload"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}