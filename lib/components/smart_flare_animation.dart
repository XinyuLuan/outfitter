import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:outfitter/components/photoPage.dart';

import 'cameraView.dart';

enum AnimationToPlay {
  Activate,
  Deactivate,
  CameraTapped,
  PulseTapped,
  ImageTapped
}

class SmartFlareAnimation extends StatefulWidget {
  @override
  _SmartFlareAnimationState createState() => _SmartFlareAnimationState();
}

class _SmartFlareAnimationState extends State<SmartFlareAnimation> {

  // create out flare controls
  final FlareControls animationControls = FlareControls();

  // reference of database
  final DatabaseReference ref = FirebaseDatabase.instance.reference();

  // give a default value with deactivate
  AnimationToPlay _animationToPlay = AnimationToPlay.Deactivate;
  AnimationToPlay _lastPlayedAnimation;
  // width and height retrieved from he artboard values in the animation(by tutorial)
  static const double AnimationWidth = 295.0;
  static const double AnimationHeight = 251.0;

  bool isOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AnimationWidth,
      height: AnimationHeight,
      child: GestureDetector(
        onTapUp: (tapInfo) {
          var localTouchPosition = (context.findRenderObject() as RenderBox)
              .globalToLocal(tapInfo.globalPosition);
          //Where we touch
          var topHalfTouched = localTouchPosition.dy < AnimationHeight * 1 / 3;
          var leftHalfTouched = localTouchPosition.dx < AnimationWidth * 2 / 5;
          var rightHalfTouched = localTouchPosition.dx > AnimationWidth * 3 / 5;
          var middleTouched = !leftHalfTouched && !rightHalfTouched;

          if( leftHalfTouched && topHalfTouched) {
            _setAnimationToPlay(AnimationToPlay.CameraTapped);
//            _pickImage(ImageSource.camera);
            WidgetsFlutterBinding.ensureInitialized();

            // Obtain a list of the available cameras on the device.
            availableCameras().then((cameras) async {
              // Get a specific camera from the list of available cameras.
              final firstCamera = cameras.first;
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TakePictureScreen(camera: firstCamera)
                ),
              );
              if(result != null){
                var timeStamp = new DateTime.now().millisecondsSinceEpoch;
                print("result URL0: " + result[0]);
                print("result URL1: " + result[1].toString());
                ref.child("photos/" + timeStamp.toString()).set({
                  "timeStamp": timeStamp,
                  "image" : result[0].toString(),
                  "selected" : "false",
                  "type" : result[1].toString(),
                }).then((ml){
                  print("save image info successful");
                }).catchError((e){
                  print("Failed to save image info " + e.toString());
                });
              }

            });
          }
          else if(middleTouched && topHalfTouched) {
            _setAnimationToPlay(AnimationToPlay.PulseTapped);
          }
          else if(rightHalfTouched && topHalfTouched){
            _setAnimationToPlay(AnimationToPlay.ImageTapped);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PhotoPage()),
            );
          }
          else{
            if(isOpen){
              _setAnimationToPlay(AnimationToPlay.Deactivate);
            }
            else{
              _setAnimationToPlay(AnimationToPlay.Activate);
            }
            setState(() {
              isOpen = !isOpen;
            });
          }

        },
        child: Center(
          child: FlareActor(
            'assets/button-animation.flr',
            controller: animationControls,
            animation: _getAnimationName(_animationToPlay),  //FlareActor
          ),

        ),
      ),
    );
  }

  String _getAnimationName(AnimationToPlay animationToPlay) {
    switch (animationToPlay) {
      case AnimationToPlay.Activate:
        return 'activate';
      case AnimationToPlay.Deactivate:
        return 'deactivate';
      case AnimationToPlay.CameraTapped:
        return 'camera_tapped';
      case AnimationToPlay.PulseTapped:
        return 'pulse_tapped';
      case AnimationToPlay.ImageTapped:
        return 'image_tapped';
      default:
        return 'deactivate';
    }
  }

  void _setAnimationToPlay(AnimationToPlay animation) {
//    setState(() {
//      _animationToPlay = animation;
//    });
    var isTappedAnimation = _getAnimationName(animation).contains("_tapped");
    if( isTappedAnimation && _lastPlayedAnimation == AnimationToPlay.Deactivate){
      return;
    }
    animationControls.play(_getAnimationName(animation));

    // remember our last played animation
    _lastPlayedAnimation = animation;
  }
}

