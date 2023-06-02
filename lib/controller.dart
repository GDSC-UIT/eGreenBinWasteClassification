import 'package:web_socket_channel/io.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  }

  void connectEsp(String espUrlInput) {
    try {
      espUrl = "ws://$espUrlInput:81";

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
          Get.snackbar(
            'Error occurred while connecting IOT system',
            'Try to reconnect',
          );
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
    label.value = await uploadImageToDetect(image.value);
    print("label value:${label.value}");
    isProcess.value = false;
  }

  Future<String> uploadImageToDetect(File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://34.147.108.136/predict'));

    // Thêm file ảnh vào yêu cầu đa phần
    var imageStream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('img_file', imageStream, length,
        filename: imageFile.path);

    request.files.add(multipartFile);

    // Gửi yêu cầu và xử lý phản hồi
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseString);
      print('Upload thành công! Phản hồi: ${jsonResponse["label"]}');
      return jsonResponse["label"];
    } else {
      print('Upload thất bại. Mã lỗi: ${response.statusCode}');
      return throw Exception('Something went wrong while detecting');
    }
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
        print("labal trash: ${label.value}");
        channel.sink.add(label.value);
        await Future.delayed(const Duration(seconds: 5));
        reset();
      }
    } catch (e) {
      print(e); //show error
    }
  }
}
