import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
            print("result URL: " + result[0]);
            Navigator.pop(context, result);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

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
          Image.file(File(widget.imagePath)),
//          TextField(
//            controller: typeTextController,
//            obscureText: false,
//            decoration: InputDecoration(
//              border: OutlineInputBorder(),
//              labelText: 'Type',
//            ),
//          ),
          RadioListTile<type4Cloth>(
            title: const Text('top'),
            value: type4Cloth.top,
            groupValue: _type,
            onChanged: (type4Cloth value) {
              setState(() {
                _type = value;
              });
            },
          ),
          RadioListTile<type4Cloth>(
            title: const Text('pants'),
            value: type4Cloth.pants,
            groupValue: _type,
            onChanged: (type4Cloth value) {
              setState(() {
                _type = value;
              });
            },
          ),
          RadioListTile<type4Cloth>(
            title: const Text('shoes'),
            value: type4Cloth.shoes,
            groupValue: _type,
            onChanged: (type4Cloth value) {
              setState(() {
                _type = value;
              });
            },
          ),
          RaisedButton(
            onPressed: () {
              print(widget.imagePath);
              _uploadFile(context, _type.toString());
              print("type: " + _type.toString());
            },
            child: Text("Upload"),
          ),
        ],
      ),
    );
  }
}