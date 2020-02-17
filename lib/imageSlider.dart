import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
//  PageController pageController;

  int _current = 1;
  //image list
  List<String> images = ['assets/tops/Tshirt1.png', 'assets/tops/Tshirt2.png'];
  List<String> pants = ['assets/pants/pants1.png', 'assets/pants/pants2.png'];
  List<String> shoes = ['assets/shoes/shoes1.png', 'assets/shoes/shoes2.png'];

//  @override
//  void initState() {
//    super.initState();
//    pageController = PageController(initialPage: 1, viewportFraction: 0.8);
//  }

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
            enlargeCenterPage: true,    //make center image larger
            //autoPlay: true,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: images.map((img) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width, //screen width
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
//                    decoration: BoxDecoration(color: Colors.amberAccent),
                    child: Image.asset(
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
            enlargeCenterPage: true,    //make center image larger
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
                    child: Image.asset(
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
            enlargeCenterPage: true,    //make center image larger
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
                    child: Image.asset(
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

