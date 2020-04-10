import 'package:flutter/material.dart';

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';


class Uploader extends StatefulWidget {
  final File file;
  Uploader({Key key, this.file}) : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {

  FirebaseStorage storage = FirebaseStorage.instance;




  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
