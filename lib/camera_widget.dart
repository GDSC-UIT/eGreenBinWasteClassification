import 'package:camera/camera.dart';
import 'package:esp_app/controller.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:get/get.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  List<CameraDescription>?
      cameras; //list out the camera available//list out the camera available

  File? image; //for captured image

  final AppController appController = Get.find();

  void loadCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null) {
        appController.cameraController =
            CameraController(cameras![0], ResolutionPreset.max);
        //cameras[0] = first camera, change to 1 to another camera
        print("controller is null ${appController.cameraController == null}");
        appController.cameraController!.setFlashMode(FlashMode.off);

        appController.cameraController!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      } else {
        print("NO any camera found");
      }
    } catch (e) {
      print("error occurred: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return SizedBox(
      child: appController.cameraController == null
          ? const Center(child: Text("Loading Camera..."))
          : !appController.cameraController!.value.isInitialized
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : AspectRatio(
                  aspectRatio: 1 / 0.7,
                  child: ClipRect(
                    child: Transform.scale(
                      scale: appController.cameraController!.value.aspectRatio /
                          0.7,
                      child: Center(
                        child: CameraPreview(appController.cameraController!),
                      ),
                    ),
                  ),
                ),
    );
  }
}
