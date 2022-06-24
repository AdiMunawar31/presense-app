import 'package:d2ypresence/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  final TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> newPassword() async {
    if (passwordController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        if (passwordController.text != 'password') {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(passwordController.text);

          await auth.signOut();

          await auth
              .signInWithEmailAndPassword(
                  email: email, password: passwordController.text)
              .then((value) => {
                    Get.offAllNamed(Routes.HOME),
                    Get.snackbar(
                      'Success',
                      'Password successfully changed',
                      backgroundColor: Colors.black38,
                      colorText: Colors.white,
                    ),
                  });
        } else {
          isLoading.value = false;
          Get.snackbar(
            'Password must be new',
            'The password cannot be the same as the default',
            backgroundColor: Colors.black38,
            colorText: Colors.white,
          );
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar(
            'Weak Password',
            'Password should be at least 6 character.',
            backgroundColor: Colors.black38,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            e.code,
            e.message!,
            backgroundColor: Colors.black38,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          '500',
          'Internal Server Error',
          backgroundColor: Colors.black38,
          colorText: Colors.white,
        );
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Password is required',
        'Password inputs must be filled in',
        backgroundColor: Colors.black38,
        colorText: Colors.white,
      );
    }
  }
}
