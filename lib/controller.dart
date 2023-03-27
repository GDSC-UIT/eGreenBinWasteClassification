import 'package:web_socket_channel/io.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

class AppController extends GetxController {
  Rx<File> image = File("").obs; //for captured image
  RxString label = "".obs;
  RxBool isWaiting = true.obs;
  RxBool isProcess = false.obs;
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  final RxBool _isInitialized = RxBool(false);
  bool get isInitialized => _isInitialized.value;
  CameraController get cameraController => _cameraController;

  late IOWebSocketChannel channel;

  String espUrl = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCamera();
    connectEsp("192.168.1.13");
  }

  void connectEsp(String espUrlInput) {
    try {
      espUrl = "ws://$espUrlInput:81";
      print("url:$espUrl");
      channel = IOWebSocketChannel.connect(espUrl);
      channel.stream.listen(
        (message) {
          print('Received from MCU: $message');
          String signal = message;
          switch (signal) {
            case "capture":
              {
                captureImage();
                break;
              }
            default:
              print(' invalid entry');
          }
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } on SocketException catch (socketException) {
      print("Caught SocketException ff: $socketException");
    }
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
  Future<void> detectImage() async {
    print("start detection");
    var result = await Tflite.runModelOnImage(
      path: image.value.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print("result: $result");
    label.value = result![0]["label"];
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
        print("capture image");
        isWaiting.value = false;
        isProcess.value = true;
        XFile recordImage =
            await cameraController.takePicture(); //capture image
        print("path of image after take is ${recordImage.path}");
        image.value = File(recordImage.path);
        await detectImage();
        print("labal trash ${label.value}");
        channel.sink.add(label.value);
      }
    } catch (e) {
      print(e); //show error
    }
  }
}
