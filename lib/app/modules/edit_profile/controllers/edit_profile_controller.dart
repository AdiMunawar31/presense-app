import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final TextEditingController nipController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> editProfile(String uid) async {
    if (nipController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await firestore.collection('employee').doc(uid).update({
          'name': nameController.text,
        }).then((value) => {
              Get.snackbar(
                'Success',
                'Your profile edited successfully',
                backgroundColor: Colors.black38,
                colorText: Colors.white,
              ),
            });
      } on FirebaseAuthException catch (e) {
        Get.snackbar(
          e.code,
          e.message!,
          backgroundColor: Colors.black38,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          '500',
          'Internal Server Error',
          backgroundColor: Colors.black38,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        'Name is required',
        'Name inputs must be filled in',
        backgroundColor: Colors.black38,
        colorText: Colors.white,
      );
    }
  }
}
