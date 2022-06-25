import 'package:d2ypresence/app/widgets/color_button.dart';
import 'package:d2ypresence/app/widgets/input_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FORGOT PASSWORD'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/images/logo.png',
                  width: 160,
                ),
                const SizedBox(height: 8.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Don't Worry! it happens. Please enter the address associated with your account.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),
                inputItem(
                  context,
                  'Email',
                  controller.emailController,
                  false,
                  const Icon(CupertinoIcons.at_circle),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => colorButton(
                      context,
                      controller.isLoading.isFalse
                          ? 'SEND EMAIL'
                          : 'LOADING...', () async {
                    if (controller.isLoading.isFalse) {
                      await controller.forgotPassword();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
