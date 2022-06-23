import 'package:d2ypresence/app/widgets/color_button.dart';
import 'package:d2ypresence/app/widgets/input_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NEW PASSWORD'),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Please change your password to secure your account!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),
                inputItem(
                  context,
                  'Password',
                  controller.passwordController,
                  true,
                  const Icon(CupertinoIcons.lock_circle),
                ),
                const SizedBox(height: 20),
                colorButton(context, 'NEW PASSWORD', () {
                  controller.newPassword();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
