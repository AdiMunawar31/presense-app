import 'package:d2ypresence/app/widgets/color_button.dart';
import 'package:d2ypresence/app/widgets/input_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHANGE PASSWORD'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/change_pass.png',
                  width: 260,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Set the new password for your account',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),

                /* NIP */

                inputItem(
                  context,
                  'Current Password',
                  controller.currentController,
                  true,
                  const Icon(CupertinoIcons.lock_circle),
                ),

                /* EMAIL */

                const SizedBox(height: 20),
                inputItem(
                  context,
                  'New Password',
                  controller.newController,
                  true,
                  const Icon(CupertinoIcons.lock_circle),
                ),

                /* CURRENT PASSWORD */
                const SizedBox(height: 20),
                inputItem(
                  context,
                  'Confirm Password',
                  controller.confirmController,
                  true,
                  const Icon(CupertinoIcons.lock_circle),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => colorButton(
                      context,
                      controller.isLoading.isFalse
                          ? 'CHANGE PASSWORD'
                          : 'LOADING...', () async {
                    if (controller.isLoading.isFalse) {
                      await controller.changePassword();
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
