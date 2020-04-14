import 'package:flutter/material.dart';

// This package provides internationalization and localization facilities,
// including message translation, plurals and genders, date/number formatting
// and parsing, and bidirectional text.
import 'package:intl/intl.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


import 'display_pictureScreen.dart';

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  File sampleImage; // the image we selected
  String _myvalue;
  String url;
  final formKey = new GlobalKey<FormState>();
  // When creating the form, provide a *GlobalKey*. The uniquely identifies the Form
  // and allows validation of the form in a later step

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("path: " + tempImage.path);
    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave(){
    final form = formKey.currentState;
    // if the form is valid, display a snackbar. In the real world,
    // you'd often call a server or save the information in a database

    // The FormState class contains the validate() method.
    // When the validate() method is called, it runs the validator() function
    // for each text field in the form. If everything looks good,
    // the validate() method returns true. If any text field contains errors,
    // the validate() method rebuilds the form to display any error messages
    // and returns false.
    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

//  void uploadStatusImage() async {
//    if(validateAndSave()){
//      /* put the image to firebase */
//      // the reference to contact the database in firebase, we can
//      // directly contact to the firebase because of the google-services.json file
//      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
//
//      // use time to be the random key
//      var timeKey = DateTime.now();
//
//      // storage
//      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
//
////      var imageUrl = await( await uploadTask.onComplete).ref.getDownloadURL();
////
////      url = imageUrl.toString();
////      print("image url = " + url);
//      goToHomePage();
////      saveToDatabase(url);
//    }
//  }

  void saveToDatabase(url){
    /**
     * update the image information to database
     */
    // using intl
    var dbTimeKey = DateTime.now();
    var formatDate= DateFormat("MMM d, yyyy");
    var formatTime = DateFormat("EEEE, hh:mm aaa"); // aaa -> am or pm

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

//    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "description": _myvalue,
      "date": date,
      "time": time,
    };

//    ref.child("Posts").push().set(data);
  }

  void toDisplayImage() async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(imagePath: sampleImage.path),
      ),
    );
    print("result URL: " + result[0]);
    Navigator.pop(context, result);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: new Text("Upload Image"),
//        centerTitle: true,
//      ),
      body: Center(
        child: sampleImage == null ? Text("Select an image"): DisplayPictureScreen(imagePath: sampleImage.path),
      ),

//      floatingActionButton: new FloatingActionButton(
//        onPressed: getImage,
//        tooltip: 'Add Image',
//        child: Icon(Icons.add_a_photo),
//      ),
    );
  }

//  Widget enableUpload(){
//    return Container(
//      child: Form(
//        key: formKey,
//        child: Column(
//          children: <Widget>[
//            Image.file(sampleImage, height: 250.0, width: 630.0,),
//            SizedBox(height: 15.0,),
//            TextFormField(
//              decoration: InputDecoration(labelText: 'Description'),
//              validator: (value){
//                return value.isEmpty ? 'Blod Description is required' : null;
//              },
//              onSaved: (value){
//                return _myvalue = value;
//              },
//            ),
//            SizedBox(height: 15.0,),
//            RaisedButton(
//              elevation: 10.0,
//              child: Text("Add"),
//              textColor: Colors.black,
//              color: Colors.amber,
//              onPressed: uploadStatusImage,
//              // Validate return true if the form is valid, otherwise false
//            ),
//          ],
//        ),
//      ),
//    );
//  }

}

