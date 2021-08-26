import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:outfitter/components/imageSlider.dart';

import 'package:outfitter/components/flare_button.dart';
import 'package:outfitter/components/singleCard.dart';


class TwoPanels2 extends StatefulWidget {
  final AnimationController controller;

  TwoPanels2({this.controller});
  @override
  _TwoPanels2State createState() => _TwoPanels2State();
}

class _TwoPanels2State extends State<TwoPanels2> {

  final DatabaseReference ref = FirebaseDatabase.instance.reference();

  var imageList = [];
  List<String> tops = [];
  List<String> pants = [];
  List<String> shoes = [];
//
//  _TwoPanels2State() {
//    ref.child("photos/").once().then((DataSnapshot snapshot) {
////      print('Data is Cofifi : ${snapshot.value}');
//      var tempList = [];
//      print("Load images successful in panel");
//      snapshot.value.forEach((k, v){
//        tempList.add(v);
//      });
//      tempList.sort((a,b) => a['timeStamp'].compareTo(b['timeStamp']));
//      setState(() {
//        imageList = tempList;
//      });
//      print("imageList: $imageList" + " length:  ${imageList.length}");
//
//      List<String> topsTemp = [];
//      List<String> pantsTemp = [];
//      List<String> shoesTemp = [];
//
//      imageList.forEach((v) {
//        if (v['selected'] == true) {
//          if (v['type'] == "type4Cloth.top" && v['image'] != null) {
//            topsTemp.add(v['image']);
//          }
//          if (v['type'] == "type4Cloth.pants" && v['image'] != null) {
//            pantsTemp.add(v['image']);
//          }
//          if (v['type'] == "type4Cloth.shoes" && v['image'] != null) {
//            shoesTemp.add(v['image']);
//          }
//        }
//      });
//      print("Inside selectedImage: " + imageList.toString());
//      setState(() {
//        tops = topsTemp;
//      });
//      print("Tops (in twoPanals2) : " + tops.toString());
//    }).catchError((e){
//      print('Failed to load firebase image in (TwoPanels2)');
//    });
//  }

  static const header_height = 32.0;

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    return new RelativeRectTween(
        begin: new RelativeRect.fromLTRB(
            0.0, backPanelHeight, 0.0, frontPanelHeight),
        end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(new CurvedAnimation(
        parent: widget.controller, curve: Curves.linear));
  }

  void _loadImage(){
    ref.child("photos/").once().then((DataSnapshot snapshot) {
      var tempList = [];
      print("Load images successful in panel");
      snapshot.value.forEach((k, v){
        tempList.add(v);
      });
      tempList.sort((a,b) => a['timeStamp'].compareTo(b['timeStamp']));
      setState(() {
        imageList = tempList;
      });
      print("imageList: $imageList" + " length:  ${imageList.length}");

      List<String> topsTemp = [];
      List<String> pantsTemp = [];
      List<String> shoesTemp = [];

      imageList.forEach((v) {
        if (v['selected'] == true) {
          if (v['type'] == "type4Cloth.top" && v['image'] != null) {
            topsTemp.add(v['image']);
          }
          if (v['type'] == "type4Cloth.pants" && v['image'] != null) {
            pantsTemp.add(v['image']);
          }
          if (v['type'] == "type4Cloth.shoes" && v['image'] != null) {
            shoesTemp.add(v['image']);
          }
        }
      });
      print("Inside selectedImage: " + imageList.toString());
      setState(() {
        tops = topsTemp;
        pants = pantsTemp;
        shoes = shoesTemp;
      });
      print("Tops (in twoPanals2) : " + tops.toString());
    }).catchError((e){
      print('Failed to load firebase image in (TwoPanels2)');
    });
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    return new Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            color: theme.primaryColor,
            child: new Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: Container(
                      child: GridView.builder(
                          itemCount: imageList.length,
                          gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: const EdgeInsets.all(4),
//                              child: Text(imageList[index]['timeStamp'].toString()),
//                              child: Image.network(imageList[index]),
                              child: SingleCard(
                                timestamp: imageList[index]['timeStamp'] ,
                              ),
                            );
                          }),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: FlareButton(),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(height: 10.0,),
                  )
                  // if I want a overlap box, use fitbox
                ],
              ),
            ),
          ),
          new PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: new Material(
              elevation: 12.0,
              borderRadius: new BorderRadius.only(
                  topLeft: new Radius.circular(16.0),
                  topRight: new Radius.circular(16.0)),
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: header_height,
                    child: new Center(
                      child: new Text(
                        "Outfitter",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ),
                  Expanded(
                    child: new Center(
                      child: ImageSlider(tops: tops, pants: pants, shoes: shoes,),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadImage();
    ref.child("photos/").onChildChanged.listen((e){
      print("Listened to Image Info CHANGED (in two panel2)");
      _loadImage();
    });
    ref.child("photos/").onChildAdded.listen((e){
      print("Listened to Image Info ADDED (in two panel2)");
      _loadImage();
    });
  }
  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: bothPanels,
    );
  }
}
