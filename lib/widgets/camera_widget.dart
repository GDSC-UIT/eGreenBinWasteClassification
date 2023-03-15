import 'package:camera/camera.dart';
import 'package:esp_app/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AppController>(builder: (controller) {
      if (!controller.isInitialized) {
        return Container();
      }
      return Container(
        width: 300,
        height: 250,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          image: controller.isWaiting.value
              ? const DecorationImage(
                  image: AssetImage("assets/images/bg_waiting.png"),
                  fit: BoxFit.cover,
                )
              : const DecorationImage(
                  image: AssetImage("assets/images/bg_done.png"),
                  fit: BoxFit.cover,
                ),
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            controller.image.value.path == ""
                ? AspectRatio(
                    aspectRatio: 1,
                    child: ClipRect(
                      child: Transform.scale(
                        scale: controller.cameraController.value.aspectRatio,
                        child: Center(
                          child: CameraPreview(controller.cameraController),
                        ),
                      ),
                    ),
                  )
                : Image.file(
                    controller.image.value,
                    fit: BoxFit.cover,
                  ),
            const Positioned(
              child: TwoCircle(),
            )
          ],
        ),
      );
    });
  }
}

class TwoCircle extends StatelessWidget {
  const TwoCircle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: const [
      Positioned(
        bottom: 0,
        right: 15,
        child: Circle(
          color: Color(0xFF99BF6F),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Circle(
          color: Color(0xFFFFAC63),
        ),
      ),
    ]);
  }
}

class Circle extends StatelessWidget {
  final Color color;
  const Circle({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.white, width: 2),
        color: color,
      ),
    );
  }
}
