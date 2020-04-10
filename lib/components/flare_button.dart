import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:outfitter/components/smart_flare_animation.dart';

class FlareButton extends StatefulWidget {
  @override
  _FlareButtonState createState() => _FlareButtonState();
}

class _FlareButtonState extends State<FlareButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SmartFlareAnimation(),
      ),
    );
  }
}
