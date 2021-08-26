import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {

  ImageSlider({Key key, this.tops, this.pants, this.shoes}) : super(key: key);
  final List<String> tops;
  final List<String> pants;
  final List<String> shoes;
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
//  PageController pageController;

  int _current = 1;

  // ignore: non_constant_identifier_names
//  List<String> Tops;
//  _ImageSliderState(this.Tops);
  final DatabaseReference ref = FirebaseDatabase.instance.reference();
  //image list
  // ignore: non_constant_identifier_names
//  List<String> tops = ['assets/tops/Tshirt1.png', 'assets/tops/Tshirt2.png'];
//  List<String> pants = ['assets/pants/pants1.png', 'assets/pants/pants2.png'];
//  List<String> shoes = ['assets/shoes/shoes1.png', 'assets/shoes/shoes2.png'];
//  List<String> images = [];
//  List<String> pants = [];
//  List<String> shoes = [];

  @override
  void initState() {
    super.initState();
//    _selectedImage();
    print("Get into Imageslider--------------------------------------");
    print(widget.tops.toString());
    ref.child("photo").onChildChanged.listen((e){
      print(widget.tops.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            widget.tops.isEmpty?
            Container(
                padding: EdgeInsets.all(100.0),
                child: Text("")
            )
            :
            CarouselSlider(
              height: 200,
              initialPage: 0,
              enlargeCenterPage: true, //make center image larger
              //autoPlay: true,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              items: widget.tops.map((img) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width, //screen width
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
//                    decoration: BoxDecoration(color: Colors.amberAccent),
                      child:  img.contains('http')
                              ? Image.network(
                                  img,
                                  fit: BoxFit.fitHeight,
                                )
                              : Image.asset(
                                  img,
                                  fit: BoxFit.fitHeight,
                                ),
                    );
                  },
                );
              }).toList(),
            ),
            widget.pants.isEmpty?
            Container(
              padding: EdgeInsets.all(100.0),
                child: Text("")
            )
                : CarouselSlider(
              height: 250,
              initialPage: 0,
              enlargeCenterPage: true, //make center image larger
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              items: widget.pants.map((img) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width, //screen width
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
//                    decoration: BoxDecoration(color: Colors.amberAccent),
                      child: img.contains('http')
                          ? Image.network(
                              img,
                              fit: BoxFit.fitHeight,
                            )
                          : Image.asset(
                              img,
                              fit: BoxFit.fitHeight,
                            ),
                    );
                  },
                );
              }).toList(),
            ),
            widget.shoes.isEmpty ?
            Container(
                padding: EdgeInsets.all(50.0),
                child: Text("")
            )
          :CarouselSlider(
              height: 80,
              initialPage: 0,
              enlargeCenterPage: true, //make center image larger
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              items: widget.shoes.map((img) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width, //screen width
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
//                    decoration: BoxDecoration(color: Colors.amberAccent),
                      child: img.contains('http')
                          ? Image.network(
                              img,
                              fit: BoxFit.fitHeight,
                            )
                          : Image.asset(
                              img,
                              fit: BoxFit.fitHeight,
                            ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
//    return Container(
//      child: PageView.builder(
//          controller: pageController,
//          itemCount: images.length,
//          itemBuilder: (context, position){
//            return imageSlider(position, images);
//          }
//      ),
//
//    );
}

//  imageSlider(int index, List list) {
////    return AnimatedBuilder(
////      animation: pageController,
////      builder: (context, widget) {
////        double value = 1;
////        if (pageController.position.haveDimensions) {
////          value = pageController.page - index;
////          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
////        }
////        return Center(
////          child: SizedBox(
////            height: Curves.easeInOut.transform(value) * 200,
////            width: Curves.easeInOut.transform(value) * 300,
////            child: widget,
////          ),
////        );
////      },
////      child: Container(
//        child: Image.asset(list[index]),
//      ),
//    );
//  }
