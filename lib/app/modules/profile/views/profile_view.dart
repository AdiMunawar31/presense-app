import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:d2ypresence/app/common/styles.dart';
import 'package:d2ypresence/app/controllers/page_index_controller.dart';
import 'package:d2ypresence/app/routes/app_pages.dart';
import 'package:d2ypresence/app/widgets/profil_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageController = Get.find<PageIndexController>();

  ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColor,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              Map<String, dynamic>? user = snapshot.data?.data();
              String defaultProfilePic =
                  'https://ui-avatars.com/api/?name=${user?["name"]}&background=27A8FD&color=fff&bold=true';
              return SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              margin: const EdgeInsets.only(top: 24.0),
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(
                                  width: 3,
                                  color: blue100,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  (user?['profilePic'] != null && user?['profilePic'] != '')
                                      ? user!['profilePic']
                                      : defaultProfilePic,
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              user?['name'] != null ? user!['name'] : '',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: secondaryColor),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              user?['email'] != null ? user!['email'] : '',
                              style: const TextStyle(fontSize: 16, color: secondaryColor),
                            )
                          ],
                        ),
                        const SizedBox(height: 24.0),

                        /* List Tile 1 */

                        // Container(
                        //   margin: const EdgeInsets.only(
                        //       left: 16.0, right: 16.0, top: 16.0),
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: const Color(0xFF7090B0).withOpacity(0.2),
                        //         blurRadius: 20.0,
                        //         offset: const Offset(0, 10.0),
                        //       )
                        //     ],
                        //   ),
                        //   child: Material(
                        //     child: ListTile(
                        //       title: const Text(
                        //         'Set Dark Theme',
                        //         style: TextStyle(
                        //             fontSize: 16, fontWeight: FontWeight.bold),
                        //       ),
                        //       trailing: CupertinoSwitch(
                        //         value: false,
                        //         onChanged: (value) {},
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          height: size.height,
                          decoration: const BoxDecoration(
                            color: secondaryColor,
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 8.0),
                              /* Add Employee */
                              if (user?['role'] == 'admin')
                                profileItem(
                                  Icons.groups_rounded,
                                  'Add Employee',
                                  Icons.keyboard_arrow_right_rounded,
                                  () => Get.toNamed(Routes.ADD_EMPLOYEE),
                                ),

                              /* Edit Profile */
                              profileItem(
                                CupertinoIcons.create,
                                'Edit Profile',
                                Icons.keyboard_arrow_right_rounded,
                                () => Get.toNamed(
                                  Routes.EDIT_PROFILE,
                                  arguments: user,
                                ),
                              ),

                              /* Change Password */
                              profileItem(
                                Icons.key,
                                'Change Password',
                                Icons.keyboard_arrow_right_rounded,
                                () => Get.toNamed(Routes.CHANGE_PASSWORD),
                              ),

                              /* Change Password */
                              profileItem(Icons.logout_rounded, 'Logout', Icons.keyboard_arrow_right_rounded, () {
                                controller.logout(context);
                              }),
                            ],
                          ),
                        ),
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
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: primaryColor,
        items: const [
          TabItem(icon: Icons.home_filled, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Presence'),
          TabItem(icon: CupertinoIcons.person_alt, title: 'Profile'),
        ],
        initialActiveIndex: pageController.pageIndex.value, //optional, default as 0
        onTap: (int i) => pageController.changePage(i),
      ),
    );
  }
}
