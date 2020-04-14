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

  _getInfo(){
    print("Come here for single Card?");
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
      child: Hero(
        tag: '$imageUrl',
        child: Material(
          child: InkWell(
            onTap: (){
              print("Clicked");
              setState(() {
                selected = !selected;
              });
              ref.child("photos").child('${widget.timestamp}').update({
                "selected" : selected,
              }).then((v){
                print("Update selected option successful (single card)");
              }).catchError((e){
                print("Failed to update selected (single card) " + e.toString());
              });
            },
            child: GridTile(
//              footer: Container(
//                color: Colors.white54,
//                child: ListTile(
//                  leading: Text("$type", style: TextStyle(fontWeight: FontWeight.bold),),
//                ),
//              ),
                // !!! the problem is here, the text format of Image network
              child: Image.network(imageUrl != null ? '$imageUrl' : "http://tineye.com/images/widgets/mona.jpg",
              fit: BoxFit.contain,),
            ),
          ),
        ),
      ),
      shape: selected == true
          ? new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.black, width: 3.0),
          borderRadius: BorderRadius.circular(2.0))
          : new RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)),
    );
  }
}
