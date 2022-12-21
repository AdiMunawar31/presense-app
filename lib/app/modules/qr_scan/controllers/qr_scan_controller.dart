import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d2ypresence/app/widgets/toast/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class QrScanController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Map<String, dynamic> data = Get.arguments;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String? uid = auth.currentUser?.uid;

    yield* firestore.collection('employee').doc(uid).snapshots();
  }

  String scannedQr = '';

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> scanQR() async {
    try {
      scannedQr = await FlutterBarcodeScanner.scanBarcode('#37B6F8', 'Cancel', true, ScanMode.QR);
      if (auth.currentUser?.email == scannedQr) {
        await processPresence();
      } else {
        CustomToast.errorToast("Error", "QR Code ini tidak sesuai: $scannedQr");
      }
    } on PlatformException {
      CustomToast.errorToast("Error", "Internal Server Error");
    }
  }

  firstPresence(
    CollectionReference<Map<String, dynamic>> presenceCollection,
    String todayDocId,
  ) async {
    await presenceCollection.doc(todayDocId).set(
      {
        "date": DateTime.now().toIso8601String(),
        "in": {
          "date": data['date'],
          "hour": data['jam'],
          "day": data['hari'],
          "latitude": data['latitude'],
          "longitude": data['longitude'],
          "address": data['address'],
          "in_area": data['inArea'],
          "distance": data['distance'],
          "keterangan": data['keterangan']
        }
      },
    );
    Get.back();
    CustomToast.successToast("Berhasil", "Berhasil absen masuk");
  }

  checkinPresence(
    CollectionReference<Map<String, dynamic>> presenceCollection,
    String todayDocId,
  ) async {
    await presenceCollection.doc(todayDocId).set(
      {
        "date": DateTime.now().toIso8601String(),
        "in": {
          "date": data['date'],
          "hour": data['jam'],
          "day": data['hari'],
          "latitude": data['latitude'],
          "longitude": data['longitude'],
          "address": data['address'],
          "in_area": data['inArea'],
          "distance": data['distance'],
          "keterangan": data['keterangan']
        }
      },
    );
    Get.back();
    CustomToast.successToast("Berhasil", "Berhasil absen masuk");
  }

  checkoutPresence(
    CollectionReference<Map<String, dynamic>> presenceCollection,
    String todayDocId,
  ) async {
    await presenceCollection.doc(todayDocId).update(
      {
        "keluar": {
          "date": data['date'],
          "hour": data['jam'],
          "day": data['hari'],
          "latitude": data['latitude'],
          "longitude": data['longitude'],
          "address": data['address'],
          "in_area": data['inArea'],
          "distance": data['distance'],
        }
      },
    );
    Get.back();
    CustomToast.successToast("Berhasil", "Berhasil absen keluar");
  }

  Future<void> processPresence() async {
    String uid = auth.currentUser!.uid;
    DateTime now = DateTime.now();
    String todayDocId = DateFormat.yMd().format(now).replaceAll('/', '-');

    String jamStr = DateFormat.Hms().format(now).split(':').first;
    var jamSekarang = int.parse(jamStr);

    CollectionReference<Map<String, dynamic>> presenceCollection =
        firestore.collection("employee").doc(uid).collection("presence");
    QuerySnapshot<Map<String, dynamic>> snapshotPreference = await presenceCollection.get();

    if (snapshotPreference.docs.isEmpty) {
      //? :  tidak pernah ada -> setel cek di kehadiran
      firstPresence(presenceCollection, todayDocId);
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDoc = await presenceCollection.doc(todayDocId).get();

      //? : sudah ada sebelumnya ( lain hari ) -> sudah check in hari ini atau check out?
      if (todayDoc.exists == true) {
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();

        // ? : sudah absen masuk
        if (dataPresenceToday?["keluar"] != null) {
          // ? : sudah absen masuk dan keluar
          CustomToast.successToast("Berhasil", "Anda sudah absen masuk dan keluar");
        } else {
          // ? : sudah absen masuk tapi belum absen keluar
          if (jamSekarang >= 13 && jamSekarang <= 15) {
            checkoutPresence(presenceCollection, todayDocId);
          } else {
            CustomToast.errorToast("Error", "Anda hanya bisa absen keluar pada jam 13:00 - 14:30");
          }
        }
      } else {
        // ? : belum absen masuk hari ini
        checkinPresence(presenceCollection, todayDocId);
      }
    }
  }
}
