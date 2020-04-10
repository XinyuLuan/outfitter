import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:outfitter/components/imageSlider.dart';

import 'package:outfitter/components/flare_button.dart';
import 'package:outfitter/components/singleCard.dart';

class TwoPanels extends StatefulWidget {
  final AnimationController controller;

  TwoPanels({this.controller});

  @override
  _TwoPanelsState createState() => new _TwoPanelsState();
}

class _TwoPanelsState extends State<TwoPanels> {
  // reference of database
  final DatabaseReference ref = FirebaseDatabase.instance.reference();
  // ignore: non_constant_identifier_names
  var imageList = [];

//  _TwoPanelsState() {
//    _loadImage();
//  }

  _loadImage() {
    var tempList = [];
    ref.child("photos").once().then((images){
      print("Get images successful in panel");
      images.value.forEach((k, v){
        tempList.add(v);
//        print(k);
//        print(v);
      });
      tempList.sort((a,b) => a['timeStamp'].compareTo(b['timeStamp']));
      setState(() {
        imageList = tempList;
      });
      print("imageList: $imageList" + " length:  ${imageList.length}");
    }).catchError((e){
      print("Failed to get the images in panel " + e.toString());
    });
  }

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
//                  Expanded(
//                    flex: 1,
//                    child: new Text(
//                      "Back Panel",
//                      style: new TextStyle(fontSize: 24.0, color: Colors.black38),
//                    ),
//                  ),
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
                                  timestamp: imageList[index]['timeStamp'],
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
                  new Expanded(
                    child: new Center(
                      child: ImageSlider(),
                    ),
                  )
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
    ref.child("photos").onChildAdded.listen((e){
      print("image added");
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