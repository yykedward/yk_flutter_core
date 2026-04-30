/*
* @author edward
* create at 2026/4/30
*/

import 'package:flutter/material.dart';

abstract class YkState<T extends StatefulWidget> extends State<T> {

  bool didDispose = false;

  @override
  void initState() {
    didDispose = false;
    super.initState();
  }

  @override
  void dispose() {
    didDispose = true;
    super.dispose();
  }
}