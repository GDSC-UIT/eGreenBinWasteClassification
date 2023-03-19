import 'package:esp_app/connect_page.dart';
import 'package:esp_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
  //     .then((_) {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EgreenBin-IOT-Trash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConnectPage(),
    );
  }
}
