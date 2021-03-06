import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfileController extends GetxController {
  final TextEditingController nipController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();

  XFile? image;

  void pickImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print(image!.path);
      print(image!.name.split('.').last);
    } else {
      print('Image: $image');
    }
    update();
  }

  Future<void> editProfile(String uid) async {
    if (nipController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          'name': nameController.text,
        };
        if (image != null) {
          File file = File(image!.path);
          // Extentions File
          String ext = image!.name.split('.').last;

          await storage.ref('$uid/avatar.$ext').putFile(file);
          String avatar =
              await storage.ref('$uid/avatar.$ext').getDownloadURL();

          data.addAll({'profilePic': avatar});
        }

        await firestore
            .collection('employee')
            .doc(uid)
            .update(data)
            .then((value) => {
                  Get.snackbar(
                    'Success',
                    'Your profile edited successfully',
                    backgroundColor: Colors.black38,
                    colorText: Colors.white,
                  ),
                  image = null,
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
      isLoading.value = false;
      Get.snackbar(
        'Name is required',
        'Name inputs must be filled in',
        backgroundColor: Colors.black38,
        colorText: Colors.white,
      );
    }
  }
}
