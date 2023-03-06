import 'dart:ui';

import 'package:esp_app/camera_widget.dart';
import 'package:esp_app/controller.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:io';
import 'package:tflite/tflite.dart';

const String esp_url = 'ws://192.168.99.100:81';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String msg = 'not connect to ESP';
  bool isConnecting = false;
  IOWebSocketChannel? channel;

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

  void connectToEsp() {
    try {
      print("start connect");
      setState(() {
        isConnecting = true;
      });
      channel = IOWebSocketChannel.connect(esp_url);
      channel!.stream.listen(
        (message) {
          setState(() {
            isConnecting = false;
          });
          print('Received from MCU: $message');
          channel!.sink.add('Flutter received $message');

          switch (message) {
            case 'capture':
              appController.captureImage();
              break;
          }
          setState(() {
            msg = message;
          });
          //channel.sink.close(status.goingAway);
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            msg = 'disconnected';
          });
        },
        onError: (error) {
          setState(() {
            msg = 'failed to connect';
            isConnecting = false;
          });
          print(error.toString());
        },
      );
    } catch (E) {
      print("error occurred in connect ESP with error $E");
      setState(() {
        msg = 'failed to connect';
        isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //camera preview
            const CameraWidget(),
            isConnecting ? const Text("loading...") : const Text(""),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.orange,
              ),
            ),
            ElevatedButton(
              onPressed: appController.captureImage,
              child: const Text("Capture"),
            ),
            ElevatedButton(
              onPressed: connectToEsp,
              child: const Text("connect to ESP"),
            ),
            Obx(
              () => appController.output.isNotEmpty
                  ? Text(
                      "result: ${appController.output[0]}",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : const Text(""),
            ),
            Obx(
              () => appController.output.isNotEmpty
                  ? Text(
                      "path image: ${appController.path}",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : const Text(""),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
