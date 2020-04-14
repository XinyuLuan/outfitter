//import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/material.dart';
//
//import 'package:outfitter/components/imageSlider.dart';
//
//import 'package:outfitter/components/flare_button.dart';
//import 'package:outfitter/components/singleCard.dart';
//
//class TwoPanels extends StatefulWidget {
//  final AnimationController controller;
//
//  TwoPanels({this.controller});
//
//  @override
//  _TwoPanelsState createState() => new _TwoPanelsState();
//}
//
//class _TwoPanelsState extends State<TwoPanels> {
//  // reference of database
//  final DatabaseReference ref = FirebaseDatabase.instance.reference();
//  var imageList = [];
//  List<String> tops = [];
////  List<String> pants = [];
////  List<String> shoes = [];
//
//  static const header_height = 32.0;
//
//  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
//    final height = constraints.biggest.height;
//    final backPanelHeight = height - header_height;
//    final frontPanelHeight = -header_height;
//
//    return new RelativeRectTween(
//        begin: new RelativeRect.fromLTRB(
//            0.0, backPanelHeight, 0.0, frontPanelHeight),
//        end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
//        .animate(new CurvedAnimation(
//        parent: widget.controller, curve: Curves.linear));
//  }
//  _TwoPanelsState() {
//    var tempList = [];
//    ref.child("photos").child('1586846278365').once().then((il) {
//      print("Get ---------------------------- image successful");
//      print(il.value["image"]);
//      print(il.value["selected"]);
//      print(il.value["type"]);
//    }).catchError((e) {
//      print("Failed to get a single card image" + e.toString());
//    });
//    ref.child("photos").once().then((images){
//      print("Load images successful in panel");
//      images.value.forEach((k, v){
//        tempList.add(v);
//      });
//      tempList.sort((a,b) => a['timeStamp'].compareTo(b['timeStamp']));
//      imageList = tempList;
//      print("imageList: $imageList" + " length:  ${imageList.length}");
//    }).catchError((e){
//      print("catchError");
//      print("Failed to get the images in panel " + e.toString());
//    });
//    print("----------------------------The end of loadimage------------------------------------------------------");
//
//    List<String> topsTemp = [];
//    List<String> pantsTemp = [];
//    List<String> shoesTemp = [];
//
//    print("imageList^^^^^^^^^^^^^^^^^^^^^: $imageList" + " length:  ${imageList.length}");
//    imageList.forEach((v) {
//      print("v['selected']: " + v['selected'].toString());
//      if (v['selected'] == true) {
//        if (v['type'] == "type4Cloth.top" && v['image'] != null) {
//          topsTemp.add(v['image']);
//          print("&&&&&&&&&&&&&&&&&&&&&&&&&&" + topsTemp.toString());
//        }
//        if (v['type'] == "type4Cloth.pants" && v['image'] != null) {
//          pantsTemp.add(v['image']);
//        }
//        if (v['type'] == "type4Cloth.shoes" && v['image'] != null) {
//          shoesTemp.add(v['image']);
//        }
//      }
//
//    });
//    print("Inside selectedImage: " + imageList.toString());
//    tops = topsTemp;
////      pants = pantsTemp;
////      shoes = shoesTemp;
//  }
//
////  _loadImage() {
////    print("Inside load image");
////    imageList.clear();
////    var tempList = [];
////    ref.child("photos").once().then((images){
////      print("Load images successful in panel");
////      images.value.forEach((k, v){
////        print("for loop!-!-!-!");
////        tempList.add(v);
////      });
////      tempList.sort((a,b) => a['timeStamp'].compareTo(b['timeStamp']));
////      setState(() {
////        imageList = tempList;
////      });
////      print("imageList: $imageList" + " length:  ${imageList.length}");
////    }).catchError((e){
////      print("catchError");
////      print("Failed to get the images in panel " + e.toString());
////    });
////    print("----------------------------The end of loadimage------------------------------------------------------");
////  }
////
////  _selectedImage() {
////    List<String> topsTemp = [];
////    List<String> pantsTemp = [];
////    List<String> shoesTemp = [];
////
////    imageList.forEach((v) {
////      print("v['selected']: " + v['selected'].toString());
////      if (v['selected'] == false) {
////        if (v['type'] == "type4Cloth.top" && v['image'] != null) {
////          topsTemp.add(v['image']);
////        }
////        if (v['type'] == "type4Cloth.pants" && v['image'] != null) {
////          pantsTemp.add(v['image']);
////        }
////        if (v['type'] == "type4Cloth.shoes" && v['image'] != null) {
////          shoesTemp.add(v['image']);
////        }
////      }
////
////    });
////    print("Inside selectedImage: " + imageList.toString());
////    setState(() {
////      tops = topsTemp;
//////      pants = pantsTemp;
//////      shoes = shoesTemp;
////    });
////  }
////  @override
////  void initState() {
////    // TODO: implement initState
////    super.initState();
////    print("Comehere???");
////
////    ref.child("photos").onChildChanged.listen((e){
////      print("image Changed");
////      _loadImage();
////      _selectedImage();
////    });
////    ref.child("photos").onChildAdded.listen((e){
////      print("image added");
////      _loadImage();
////      _selectedImage();
////    });
////  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new LayoutBuilder(
//      builder: bothPanels,
//    );
//  }
//
//  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
//    final ThemeData theme = Theme.of(context);
//
//    return new Container(
//      child: new Stack(
//        children: <Widget>[
//          new Container(
//            color: theme.primaryColor,
//            child: new Center(
//              child: Column(
//                children: <Widget>[
//                  Expanded(
//                    flex: 8,
//                    child: Container(
//                      child: GridView.builder(
//                          itemCount: imageList.length,
//                          gridDelegate:
//                          new SliverGridDelegateWithFixedCrossAxisCount(
//                              crossAxisCount: 2),
//                          itemBuilder: (BuildContext context, int index) {
//                            return Container(
//                              padding: const EdgeInsets.all(4),
////                              child: Text(imageList[index]['timeStamp'].toString()),
////                              child: Image.network(imageList[index]),
//                              child: SingleCard(
//                                timestamp: imageList[index]['timeStamp'],
//                              ),
//                            );
//                          }),
//                    ),
//                  ),
//                  Expanded(
//                    flex: 3,
//                    child: FlareButton(),
//                  ),
//                  Expanded(
//                    flex: 1,
//                    child: SizedBox(height: 10.0,),
//                  )
//                  // if I want a overlap box, use fitbox
//                ],
//              ),
//            ),
//          ),
//          new PositionedTransition(
//            rect: getPanelAnimation(constraints),
//            child: new Material(
//              elevation: 12.0,
//              borderRadius: new BorderRadius.only(
//                  topLeft: new Radius.circular(16.0),
//                  topRight: new Radius.circular(16.0)),
//              child: new Column(
//                children: <Widget>[
//                  new Container(
//                    height: header_height,
//                    child: new Center(
//                      child: new Text(
//                        "Outfitter",
//                        style: Theme.of(context).textTheme.button,
//                      ),
//                    ),
//                  ),
//                  Expanded(
//                    child: new Center(
//                      child: ImageSlider(tops: tops,),
//                    ),
//                  )
//                ],
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//
//}