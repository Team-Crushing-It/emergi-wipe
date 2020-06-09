import 'package:flutter/material.dart';

class EmergiWipeLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(image: Theme.of(context).brightness == Brightness.dark ? AssetImage("assets/Dark Logo.png") : AssetImage("assets/EmerWipeLogo.png"));
  }
}
