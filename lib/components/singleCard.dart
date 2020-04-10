import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SingleCard extends StatefulWidget {
  SingleCard({Key key, this.timestamp}) : super(key: key);
  final int timestamp;
  @override
  _SingleCardState createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
  final DatabaseReference ref = FirebaseDatabase.instance.reference();
  String imageUrl;
  var selected;
  var type;
  var image;
//  _SingleCardState(){
//    _getInfo();
//  }

  _getInfo(){
    ref.child("photos").child('${widget.timestamp}').once().then((il) {
      print("Get a single card image successful");
      print(il.value["image"]);
      print(il.value["selected"]);
      print(il.value["type"]);
      setState(() {
        imageUrl = il.value["image"];
        selected = il.value["selected"];
        type = il.value["type"];
      });
    }).catchError((e) {
      print("Failed to get a single card image" + e.toString());
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getInfo();
    ref.child("photo").onChildChanged.listen((e){
      print("Image info got updated");
      _getInfo();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
//      child: Image.network(imageUrl,fit: BoxFit.fitWidth,),
      child: Hero(
        tag: '$imageUrl',
        child: Material(
          child: InkWell(
            onTap: (){
              print("Clicked");
              if( selected == "false"){
                setState(() {
                  selected = "true";
                });
                ref.child("photos").child('${widget.timestamp}').update({
                  "selected" : "true",
                }).then((v){
                  print("Update selected successful");
                }).catchError((e){
                  print("Failed to update selected " + e.toString());
                });
              }
              else if( selected == "true"){
                setState(() {
                  selected = "false";
                });
                ref.child("photos").child('${widget.timestamp}').update({
                  "selected" : "false",
                }).then((v){
                  print("Update selected successful");
                }).catchError((e){
                  print("Failed to update selected " + e.toString());
                });
              }

            },
            child: GridTile(
              footer: Container(
                color: Colors.white54,
                child: ListTile(
                  leading: Text("$selected-$type", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
                // !!! the problem is here, the text format of Image network
              child: Image.network(imageUrl != null ? '$imageUrl' : "http://tineye.com/images/widgets/mona.jpg",
              fit: BoxFit.cover,),
            ),
          ),
        ),
      ),
    );
  }
}
