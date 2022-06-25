import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d2ypresence/app/common/styles.dart';
import 'package:d2ypresence/app/routes/app_pages.dart';
import 'package:d2ypresence/app/widgets/profil_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('PROFILE'),
      //   centerTitle: true,
      // ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: size.height / 2.8,
                          width: size.width,
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: size.width / 1,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: secondaryColor,
                                          size: 24,
                                        )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: secondaryColor,
                                          size: 24,
                                        )),
                                  ],
                                ),
                              ),
                              ClipOval(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                    'https://ui-avatars.com/api/?name=${user["name"]}&background=27A8FD&color=fff&bold=true',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                "${user['name']}",
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryColor),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "${user['email']}",
                                style: const TextStyle(
                                    fontSize: 16, color: secondaryColor),
                              )
                            ],
                          ),
                        ),

                        /* List Tile 1 */

                        Container(
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7090B0).withOpacity(0.2),
                                blurRadius: 20.0,
                                offset: const Offset(0, 10.0),
                              )
                            ],
                          ),
                          child: Material(
                            child: ListTile(
                              title: const Text(
                                'Set Dark Theme',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              trailing: CupertinoSwitch(
                                value: false,
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                        ),

                        /* Add Employee */
                        if (user['role'] == 'admin')
                          profileItem(
                            Icons.groups_rounded,
                            'Add Employee',
                            Icons.keyboard_arrow_right_rounded,
                            () => Get.toNamed(Routes.ADD_EMPLOYEE),
                          ),

                        /* Edit Profile */
                        profileItem(
                          Icons.person,
                          'Edit Profile',
                          Icons.keyboard_arrow_right_rounded,
                          () => Get.toNamed(Routes.EDIT_PROFILE),
                        ),

                        /* Change Password */
                        profileItem(
                          Icons.key,
                          'Change Password',
                          Icons.keyboard_arrow_right_rounded,
                          () => Get.toNamed(Routes.CHANGE_PASSWORD),
                        ),

                        /* Change Password */
                        profileItem(Icons.logout_rounded, 'Logout',
                            Icons.keyboard_arrow_right_rounded, () {
                          controller.logout(context);
                        }),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('404 DATA NOT FOUND!'),
              );
            }
          }),
    );
  }
}
