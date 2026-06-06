import 'package:ar_protractor/features/camera/view/camera_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(),
      //Scaffold(body: Center(child: Text('AR Protractor'))),
    );
  }
}
