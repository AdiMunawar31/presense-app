import 'package:d2ypresence/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        if (credential.user != null) {
          if (credential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passwordController.text == 'password') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
                contentPadding: const EdgeInsets.only(bottom: 24.0, top: 12.0),
                titlePadding: const EdgeInsets.only(top: 24.0),
                title: 'Not verified email',
                content: Column(
                  children: const [
                    Text("Please verify your email first"),
                    SizedBox(height: 12),
                    Text("or Send Email again?"),
                  ],
                ),
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        isLoading.value = false;
                        Get.back();
                      },
                      child: const Text('CANCEL')),
                  ElevatedButton(
                      onPressed: () async {
                        await credential.user!
                            .sendEmailVerification()
                            .then((value) => {
                                  Get.snackbar(
                                    'Success',
                                    'Verification email sent successfully',
                                    backgroundColor: Colors.black38,
                                    colorText: Colors.white,
                                  ),
                                });
                        isLoading.value = false;
                      },
                      child: const Text('SEND EMAIL')),
                ]);
          }
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar(
            'Not Found',
            'No user found for that email.',
            backgroundColor: Colors.black38,
            colorText: Colors.white,
          );
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
            'Wrong Password',
            'Wrong password provided for that user.',
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
        isLoading.value = false;
        Get.snackbar(
          '500',
          'Internal Server Error',
          backgroundColor: Colors.black38,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'There is an error',
        'All inputs must be filled in',
        backgroundColor: Colors.black38,
        colorText: Colors.white,
      );
    }
  }
}
