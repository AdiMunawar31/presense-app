import 'package:d2ypresence/app/widgets/color_button.dart';
import 'package:d2ypresence/app/widgets/input_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
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
                const Text(
                  'Please login to continue using our app',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
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
                inputItem(
                  context,
                  'Password',
                  controller.passwordController,
                  true,
                  const Icon(CupertinoIcons.lock_circle),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => colorButton(context,
                      controller.isLoading.isFalse ? 'LOGIN' : 'LOADING...',
                      () async {
                    if (controller.isLoading.isFalse) {
                      await controller.login();
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
