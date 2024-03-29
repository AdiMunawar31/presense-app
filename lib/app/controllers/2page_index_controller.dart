// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:d2ypresence/app/routes/app_pages.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class PageIndexController extends GetxController {
//   RxInt pageIndex = 0.obs;

//   FirebaseAuth auth = FirebaseAuth.instance;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   void changePage(int i) async {
//     switch (i) {
//       case 1:
//         Map<String, dynamic> response = await _determinePosition();
//         if (!(response['error'])) {
//           Position position = response['position'];

//           List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

//           print(placemarks[0]);

//           String address =
//               '${placemarks[0].subLocality} - ${placemarks[0].locality} - ${placemarks[0].subAdministrativeArea}';

//           await updatePosition(position, address);

//           // -6.803129646912052, 108.4838878199461,
//           double distance = Geolocator.distanceBetween(-6.8049947, 108.4787143, position.latitude, position.longitude);
//           print(distance);

//           DateTime now = DateTime.now();
//           String hourString = DateFormat.Hms().format(now).split(':').first;
//           var hour = int.parse(hourString);
//           print(hour);
//           // cek apakah posisi berada di dalam area
//           if (distance <= 10) {
//             if (hour >= 8 && hour <= 16) {
//               await presence(position, address, distance);
//             } else {
//               Get.snackbar(
//                 'Waktu Tidak Sesuai',
//                 'Kamu hanya bisa absen pada jam 08:00 - 16:00',
//                 backgroundColor: Colors.black38,
//                 colorText: Colors.white,
//               );
//             }
//           } else {
//             Get.snackbar(
//               'Location Error',
//               'Kamu Berada diluar Area',
//               backgroundColor: Colors.black38,
//               colorText: Colors.white,
//             );
//           }
//         } else {
//           Get.snackbar(
//             'Location Error',
//             response['message'],
//             backgroundColor: Colors.black38,
//             colorText: Colors.white,
//           );
//         }

//         break;
//       case 2:
//         pageIndex.value = i;
//         Get.offAllNamed(Routes.PROFILE);
//         break;
//       default:
//         pageIndex.value = i;
//         Get.offAllNamed(Routes.HOME);
//     }
//   }

//   /* Presence */

//   Future<void> presence(Position position, String address, double distance) async {
//     String uid = auth.currentUser!.uid;

//     CollectionReference<Map<String, dynamic>> collectionPresence =
//         firestore.collection('employee').doc(uid).collection('presence');

//     QuerySnapshot<Map<String, dynamic>> snapPresence = await collectionPresence.get();

//     DateTime now = DateTime.now();
//     String hour = DateFormat.Hms().format(now);
//     String day = DateFormat.yMMMMEEEEd('id_ID').format(now);
//     String todayId = DateFormat.yMd().format(now).replaceAll('/', '-');

//     String hourString = DateFormat.Hms().format(now).split(':').first;
//     var currentHour = int.parse(hourString);

//     String status = 'Outside the area';
//     print('Distance : $distance');

//     if (distance <= 10) {
//       status = 'Inside the area';
//     }

//     if (snapPresence.docs.isEmpty) {
//       await Get.defaultDialog(
//           contentPadding: const EdgeInsets.only(bottom: 24.0, top: 12.0),
//           titlePadding: const EdgeInsets.only(top: 24.0),
//           title: 'Validation Presence In',
//           content: Column(
//             children: const [
//               Text("Verification presence in today?"),
//             ],
//           ),
//           actions: [
//             OutlinedButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
//             ElevatedButton(
//                 onPressed: () async {
//                   await collectionPresence.doc(todayId).set({
//                     'date': now.toIso8601String(),
//                     'in': {
//                       'date': now.toIso8601String(),
//                       'hour': hour,
//                       'day': day,
//                       'lat': position.latitude,
//                       'long': position.longitude,
//                       'address': address,
//                       'status': status,
//                       'distance': distance.toStringAsFixed(2),
//                     }
//                   });
//                   Get.back();
//                   Get.snackbar(
//                     'Success',
//                     "You have filled in today's presence list",
//                     backgroundColor: Colors.black38,
//                     colorText: Colors.white,
//                   );
//                 },
//                 child: const Text(
//                   'VALIDATE',
//                 )),
//           ]);
//     } else {
//       DocumentSnapshot<Map<String, dynamic>> todayDocument = await collectionPresence.doc(todayId).get();
//       if (todayDocument.exists) {
//         Map<String, dynamic>? todayPresenceData = todayDocument.data();
//         if (todayPresenceData!['out'] != null) {
//           Get.snackbar(
//             'Warning',
//             'You have done presence today',
//             backgroundColor: Colors.black38,
//             colorText: Colors.white,
//           );
//         } else {
//           if (currentHour >= 15 && currentHour <= 16) {
//             await Get.defaultDialog(
//                 contentPadding: const EdgeInsets.only(bottom: 24.0, top: 12.0),
//                 titlePadding: const EdgeInsets.only(top: 24.0),
//                 title: 'Validation Presence Out',
//                 content: Column(
//                   children: const [
//                     Text("Verification presence out today?"),
//                   ],
//                 ),
//                 actions: [
//                   OutlinedButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
//                   ElevatedButton(
//                       onPressed: () async {
//                         await collectionPresence.doc(todayId).update({
//                           'date': now.toIso8601String(),
//                           'out': {
//                             'date': now.toIso8601String(),
//                             'hour': hour,
//                             'day': day,
//                             'lat': position.latitude,
//                             'long': position.longitude,
//                             'address': address,
//                             'status': status,
//                             'distance': distance.toStringAsFixed(2),
//                           }
//                         });
//                         Get.back();
//                         Get.snackbar(
//                           'Success',
//                           "You have filled out today's presence list",
//                           backgroundColor: Colors.black38,
//                           colorText: Colors.white,
//                         );
//                       },
//                       child: const Text(
//                         'VALIDATE',
//                       )),
//                 ]);
//           } else {
//             Get.snackbar(
//               'Waktu Tidak Sesuai',
//               'Kamu hanya bisa absen keluar pada jam 15:00 - 16:00',
//               backgroundColor: Colors.black38,
//               colorText: Colors.white,
//             );
//           }
//         }
//       } else {
//         // Absen Masuk jika sudah ada data
//         await Get.defaultDialog(
//             contentPadding: const EdgeInsets.only(bottom: 24.0, top: 12.0),
//             titlePadding: const EdgeInsets.only(top: 24.0),
//             title: 'Validation Presence In',
//             content: Column(
//               children: const [
//                 Text("Verification presence in today?"),
//               ],
//             ),
//             actions: [
//               OutlinedButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
//               ElevatedButton(
//                   onPressed: () async {
//                     await collectionPresence.doc(todayId).set({
//                       'date': now.toIso8601String(),
//                       'in': {
//                         'date': now.toIso8601String(),
//                         'hour': hour,
//                         'day': day,
//                         'lat': position.latitude,
//                         'long': position.longitude,
//                         'address': address,
//                         'status': status,
//                         'distance': distance.toStringAsFixed(2),
//                       }
//                     });
//                     Get.back();
//                     Get.snackbar(
//                       'Success',
//                       "You have filled in today's presence list",
//                       backgroundColor: Colors.black38,
//                       colorText: Colors.white,
//                     );
//                   },
//                   child: const Text(
//                     'VALIDATE',
//                   )),
//             ]);
//       }
//     }
//   }

//   /* Update Position */

//   Future<void> updatePosition(Position position, String address) async {
//     String uid = auth.currentUser!.uid;

//     await firestore.collection('employee').doc(uid).update({
//       'position': {
//         'lat': position.latitude,
//         'long': position.longitude,
//       },
//       'address': address,
//     });
//   }

//   Future<Map<String, dynamic>> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return {
//         'message': 'Location services are disabled.',
//         'error': true,
//       };
//       // return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return {
//           'message': 'Location permissions are denied',
//           'error': true,
//         };
//         // return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return {
//         'message': 'Location permissions are permanently denied, we cannot request permissions.',
//         'error': true,
//       };
//       // return Future.error(
//       //     'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     return {
//       'position': position,
//       'message': 'Successfully got your current location',
//       'error': false,
//     };
//   }
// }
