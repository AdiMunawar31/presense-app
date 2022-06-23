import 'package:d2ypresence/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        if (credential.user != null) {
          if (credential.user!.emailVerified == true) {
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
              buttonColor: Colors.blue,
              textConfirm: "Send Email",
              textCancel: "Back",
              confirmTextColor: Colors.white,
              content: Column(
                children: const [
                  Text("Please verify your email first"),
                  SizedBox(height: 12),
                  Text("or Send Email again?"),
                ],
              ),
              onConfirm: () async {
                await credential.user!.sendEmailVerification().then((value) => {
                      Get.snackbar(
                        'Success',
                        'Verification email sent successfully',
                        backgroundColor: Colors.black38,
                        colorText: Colors.white,
                      ),
                    });
              },
            );
          }
        }
      } on FirebaseAuthException catch (e) {
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
