import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:d2ypresence/app/common/styles.dart';
import 'package:d2ypresence/app/controllers/page_index_controller.dart';
import 'package:d2ypresence/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageController = Get.find<PageIndexController>();

  HomeView({Key? key}) : super(key: key);

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
              Map<String, dynamic> user = snapshot.data!.data()!;
              String defaultProfilePic =
                  'https://ui-avatars.com/api/?name=${user["name"]}&background=27A8FD&color=fff&bold=true';

              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(
                                  width: 2,
                                  color: blue100,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Image.network(
                                  (user['profilePic'] != null && user['profilePic'] != '')
                                      ? user['profilePic']
                                      : defaultProfilePic,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                SizedBox(
                                  width: 230,
                                  child: Text(
                                    user["address"] != null ? '${user["address"]}' : 'Location not yet available',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      /* Section 2 */

                      Container(
                        // height: size.height,
                        width: size.width,
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              //! CARD 1

                              Container(
                                height: 180,
                                width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topLeft, end: Alignment(0.8, 0.0), colors: [blue300, blue400]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7090B0).withOpacity(0.2),
                                      blurRadius: 20.0,
                                      offset: const Offset(0, 10.0),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['job'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 40.0),
                                      Text(
                                        user['nip'],
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Kredit',
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        user['name'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24.0),
                              //! CARD 2

                              Container(
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7090B0).withOpacity(0.2),
                                      blurRadius: 20.0,
                                      offset: const Offset(0, 10.0),
                                    )
                                  ],
                                ),
                                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: controller.streamTodayUser(),
                                    builder: (context, snapshotToday) {
                                      if (snapshotToday.connectionState == ConnectionState.waiting) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            Container(
                                              height: 40.0,
                                              width: 2.0,
                                              color: Colors.grey[300],
                                            ),
                                            const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ],
                                        );
                                      }

                                      Map<String, dynamic>? dataToday = snapshotToday.data?.data();
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              const Text(
                                                'Today In',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2.0),
                                              Text(dataToday?['in'] == null
                                                  ? '-'
                                                  : DateFormat.Hms().format(
                                                      DateTime.parse(dataToday?['in']['date']),
                                                    )),
                                            ],
                                          ),
                                          Container(
                                            height: 40.0,
                                            width: 2.0,
                                            color: Colors.grey[300],
                                          ),
                                          Column(
                                            children: [
                                              const Text(
                                                'Today Out',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 2.0),
                                              Text(dataToday?['out'] == null
                                                  ? '-'
                                                  : DateFormat.Hms().format(
                                                      DateTime.parse(dataToday?['out']['date']),
                                                    )),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              const SizedBox(height: 24.0),

                              Divider(
                                color: Colors.grey[300],
                                thickness: 2,
                              ),

                              const SizedBox(height: 8.0),

                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Last 5 days',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Get.toNamed(Routes.ALL_PRESENCE),
                                      child: const Text(
                                        'See More',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: blue400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              //! CARD 3

                              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                  stream: controller.streamLastUser(),
                                  builder: (context, snapshotPresence) {
                                    if (snapshotPresence.connectionState == ConnectionState.waiting) {
                                      return SizedBox(
                                        height: size.height / 5,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    if (snapshotPresence.data!.docs.isEmpty) {
                                      return SizedBox(
                                          height: size.height / 5,
                                          child: const Center(
                                            child: Text('No history presence yet',
                                                style: TextStyle(
                                                    fontSize: 16, color: primaryColor, fontWeight: FontWeight.bold)),
                                          ));
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: snapshotPresence.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> data = snapshotPresence.data!.docs[index].data();
                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 20.0),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF7090B0).withOpacity(0.2),
                                                blurRadius: 20.0,
                                                offset: const Offset(0, 10.0),
                                              )
                                            ],
                                          ),
                                          child: Material(
                                            borderRadius: BorderRadius.circular(16),
                                            color: Colors.white,
                                            child: InkWell(
                                              onTap: () => Get.toNamed(Routes.DETAIL_PRESENCE, arguments: data),
                                              borderRadius: BorderRadius.circular(16),
                                              child: Container(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Enter the office',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat.yMMMEd('id_ID').format(
                                                            DateTime.parse(data['date']),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2.0),
                                                    Text(
                                                      data['in']?['date'] == null
                                                          ? '-'
                                                          : DateFormat.jms().format(
                                                              DateTime.parse(data['in']!['date']),
                                                            ),
                                                    ),
                                                    const SizedBox(height: 12.0),
                                                    const Text(
                                                      'Out of office',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2.0),
                                                    Text(
                                                      data['out']?['date'] == null
                                                          ? '-'
                                                          : DateFormat.jms().format(
                                                              DateTime.parse(data['out']!['date']),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  })
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Text('404 DATA NOT FOUND');
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
