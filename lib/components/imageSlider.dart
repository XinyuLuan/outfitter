import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
//  PageController pageController;

  int _current = 1;
  final DatabaseReference ref = FirebaseDatabase.instance.reference();
  //image list
  // ignore: non_constant_identifier_names
  List<String> tops = ['assets/tops/Tshirt1.png', 'assets/tops/Tshirt2.png'];
  List<String> pants = ['assets/pants/pants1.png', 'assets/pants/pants2.png'];
  List<String> shoes = ['assets/shoes/shoes1.png', 'assets/shoes/shoes2.png'];
//  List<String> images = [];
//  List<String> pants = [];
//  List<String> shoes = [];

  _selectedImage() {
    List<String> topsTemp = [];
    List<String> pantsTemp = [];
    List<String> shoesTemp = [];

    ref.child("photos").once().then((il) {
      print("load all the image info successful (imageSlider)");
      print(il.value);
      il.value.forEach((k, v) {
        if (v['selected'] == "true") {
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
      print(topsTemp);
      setState(() {
        tops = topsTemp;
        pants = pantsTemp;
        shoes = shoesTemp;
      });
    }).catchError((e) {
      print("Failed to load all the image info (imageSlider) " + e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedImage();
    ref.child("photo").onChildChanged.listen((e){
      print("get selected Image list (in imageSlider)");
      _selectedImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
            items: tops.map((img) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width, //screen width
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
//                    decoration: BoxDecoration(color: Colors.amberAccent),
                    child: img.contains('http')
                        ? Image.network(
                            img,
                            fit: BoxFit.fitWidth,
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
          CarouselSlider(
            height: 250,
            initialPage: 0,
            enlargeCenterPage: true, //make center image larger
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: pants.map((img) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width, //screen width
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
//                    decoration: BoxDecoration(color: Colors.amberAccent),
                    child: img.contains('http')
                        ? Image.network(
                            img,
                            fit: BoxFit.fitWidth,
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
          CarouselSlider(
            height: 80,
            initialPage: 0,
            enlargeCenterPage: true, //make center image larger
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: shoes.map((img) {
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
