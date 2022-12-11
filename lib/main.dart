// import 'dart:async';
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stroke/console.dart';
import 'package:stroke/error_handler.dart';
//import 'package:stroke/widgets/home_page.dart';
import 'package:stroke/widgets/main_page.dart';
//import 'ffi.dart' if (dart.library.html) 'ffi_web.dart';

void main() async {
  //only required with developer mode.
  ErrorHandler.init();
  Console.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainPage());
  }
}
