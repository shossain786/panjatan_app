import 'package:flutter/material.dart';

BoxDecoration myScreenBG() {
    return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
  }