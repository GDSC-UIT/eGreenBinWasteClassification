import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

class AppController extends GetxController {
  RxList output = [].obs; //result after predict
  CameraController? cameraController; //controller for camera
  File? image; //for captured image
  RxString path = "".obs; //

  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  final RxBool _isInitialized = RxBool(false);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[1], ResolutionPreset.high);
    _cameraController.initialize().then((value) {
      _isInitialized.value = true;
      _isInitialized.refresh();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

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
