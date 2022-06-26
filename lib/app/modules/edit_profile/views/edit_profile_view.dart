import 'dart:io';

import 'package:d2ypresence/app/common/styles.dart';
import 'package:d2ypresence/app/widgets/color_button.dart';
import 'package:d2ypresence/app/widgets/input_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  final Map<String, dynamic> user = Get.arguments;

  EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.nipController.text = user['nip'];
    controller.emailController.text = user['email'];
    controller.nameController.text = user['name'];

    String defaultProfilePic =
        'https://ui-avatars.com/api/?name=${user["name"]}&background=27A8FD&color=fff&bold=true';

    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT PROFILE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                GetBuilder<EditProfileController>(
                  builder: (c) {
                    if (c.image != null) {
                      return ClipOval(
                        child: SizedBox(
                          width: 130,
                          height: 130,
                          child: Image.file(
                            File(c.image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return ClipOval(
                        child: SizedBox(
                          width: 130,
                          height: 130,
                          child: Image.network(
                            (user['profilePic'] != null &&
                                    user['profilePic'] != '')
                                ? user['profilePic']
                                : defaultProfilePic,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  },
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: TextButton(
                        onPressed: () {
                          controller.pickImage();
                        },
                        child: const Text(
                          'Change profile photo',
                          style: TextStyle(fontSize: 17),
                        ))),
                const SizedBox(height: 30),

                /* NIP */

                Container(
                  color: Colors.white,
                  height: 50,
                  child: TextFormField(
                    readOnly: true,
                    controller: controller.nipController,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: 'NIP',
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      suffixIcon: const Icon(CupertinoIcons.grid_circle),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 1.5,
                          color: primaryColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0, top: 4.0),
                    child: Text(
                      "* nip can't be changed",
                      style: TextStyle(
                          color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                /* EMAIL */

                Container(
                  color: Colors.white,
                  height: 50,
                  child: TextFormField(
                    readOnly: true,
                    controller: controller.emailController,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      suffixIcon: const Icon(CupertinoIcons.at_circle),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 1.5,
                          color: primaryColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0, top: 4.0),
                    child: Text(
                      "* email can't be changed",
                      style: TextStyle(
                          color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                /* Name */

                inputItem(
                  context,
                  'Name',
                  controller.nameController,
                  false,
                  const Icon(CupertinoIcons.person_circle),
                ),
                const SizedBox(height: 35),
                Obx(
                  () => colorButton(context,
                      controller.isLoading.isFalse ? 'UPDATE' : 'LOADING...',
                      () async {
                    if (controller.isLoading.isFalse) {
                      await controller.editProfile(user['uid']);
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
