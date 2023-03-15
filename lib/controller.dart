import 'package:esp_app/data/data.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

class AppController extends GetxController {
  //RxList output = [].obs; //result after predict
  Rx<File> image = File("").obs; //for captured image
  RxString path = "".obs;
  RxString label = "".obs;
  RxBool isWaiting = true.obs;
  RxBool isProcess = false.obs;

  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  final RxBool _isInitialized = RxBool(false);
  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    _cameraController.setFlashMode(FlashMode.off);
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
    print("start detection");
    var result = await Tflite.runModelOnImage(
      path: image.value.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print("complete detection ${result![0]}");
    print("complete detection ${result[0]["label"]}");

    label.value = result[0]["label"];

    print("label value:${label.value}");
    isProcess.value = false;
  }

  void reset() {
    isWaiting.value = true;
    isProcess.value = false;
    image.value = File("");
    label.value = "";
  }

  //capture image
  void captureImage() async {
    try {
      if (cameraController.value.isInitialized) {
        isWaiting.value = false;
        isProcess.value = true;
        print("capture image");

        XFile recordImage =
            await cameraController.takePicture(); //capture image
        print("path of image after take is ${recordImage.path}");
        image.value = File(recordImage.path);
        detectImage();
      }
    } catch (e) {
      print(e); //show error
    }
  }
}
