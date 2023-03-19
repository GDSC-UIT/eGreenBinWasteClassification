import 'package:esp_app/controller.dart';
import 'package:esp_app/home_page.dart';
import 'package:esp_app/util/colors_assets.dart';
import 'package:esp_app/util/image_assets.dart';
import 'package:esp_app/widgets/app_button.dart';
import 'package:esp_app/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectPage extends GetView<AppController> {
  ConnectPage({super.key});
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GetX<AppController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.bgConnect),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                height: height - 100,
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const Header(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Text(
                                "Enter IP Address of IoT System",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 20.0),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              AppButton(
                                onPressed: () {
                                  try {
                                    //controller.connectEsp(textController.text);
                                    Get.off(MyHomePage(title: "homepage"));
                                  } on FormatException catch (_, e) {
                                    Get.snackbar(
                                      "cannot connect try again",
                                      "$e",
                                      colorText: AppColors.red,
                                      backgroundColor: AppColors.lightGrey,
                                    );
                                  }
                                },
                                color: AppColors.subPrimary,
                                text: "Connect",
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(Assets.binImg),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}