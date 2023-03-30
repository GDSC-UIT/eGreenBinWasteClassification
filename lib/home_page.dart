import 'package:egreenbin_waste_classification/widgets/camera_widget.dart';
import 'package:egreenbin_waste_classification/controller.dart';
import 'package:egreenbin_waste_classification/widgets/content_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tflite/tflite.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AppController appController = Get.put(AppController());

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GetX<AppController>(builder: (controller) {
      if (!controller.isInitialized) {
        return Container();
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          //outermost background
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            //background white
            child: Container(
              height: height,
              width: width,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 27,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CameraView(),
                  const SizedBox(
                    width: 32,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Content(),
                                TextButton(
                                  onPressed: () {
                                    controller.reset();
                                  },
                                  child: Text("reset"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset("assets/images/logo.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
