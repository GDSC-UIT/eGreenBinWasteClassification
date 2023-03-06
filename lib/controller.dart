import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

class AppController extends GetxController {
  //RxString output = "".obs;
  RxList output = [].obs; //result after predict
  CameraController? cameraController; //controller for camera
  File? image; //for captured image
  RxString path = "".obs; //
  List<CameraDescription>? cameras;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //loadCamera();
  }

  // void loadCamera() async {
  //   try {
  //     cameras = await availableCameras();
  //     if (cameras != null) {
  //       cameraController = CameraController(cameras![1], ResolutionPreset.max);
  //       print("camera load success");
  //       //cameras[0] = first camera, change to 1 to another camera
  //       //print("controller is null ${cameraController == null}");
  //       //cameraController!.setFlashMode(FlashMode.off);

  //       // cameraController!.initialize().then((_) {
  //       //   if (!mounted) {
  //       //     return;
  //       //   }
  //       //   setState(() {});
  //       // });
  //     } else {
  //       print("NO any camera found");
  //     }
  //   } catch (e) {
  //     print("error occurred: $e");
  //   }
  // }

  //detect type of trash
  void detectImage() async {
    var result = await Tflite.runModelOnImage(
      path: image!.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    output.value = result!;
  }

  //capture image
  void captureImage() async {
    try {
      if (cameraController != null) {
        //check if contrller is not null
        if (cameraController!.value.isInitialized) {
          print("capture image");

          XFile recordImage =
              await cameraController!.takePicture(); //capture image
          print("path of image after take is " + recordImage.path);
          image = File(recordImage.path);
          path.value = recordImage.path;
          detectImage();
        }
      }
    } catch (e) {
      print(e); //show error
    }
  }
}
