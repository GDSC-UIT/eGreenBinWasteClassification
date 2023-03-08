import 'package:esp_app/widgets/process_content.dart';
import 'package:esp_app/widgets/result_content.dart';
import 'package:esp_app/widgets/waiting_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controller.dart';

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AppController>(builder: (controller) {
      return controller.isWaiting.value
          ? const WaitingContent()
          : controller.isProcess.value
              ? const ProcessContent()
              : ResultContent(label: controller.label.value);
    });
  }
}
