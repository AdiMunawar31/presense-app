import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:d2ypresence/app/widgets/dialog/custom_alert_dialog.dart';
import 'package:d2ypresence/app/widgets/toast/custom_toast.dart';
import 'package:d2ypresence/company_data.dart';

class PresenceController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  presence() async {
    isLoading.value = true;
    Map<String, dynamic> determinePosition = await _determinePosition();
    if (!determinePosition["error"]) {
      Position position = determinePosition["position"];

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      String address =
          '${placemarks[0].subLocality} - ${placemarks[0].locality} - ${placemarks[0].subAdministrativeArea} - ${placemarks[0].administrativeArea}';

      double distance = Geolocator.distanceBetween(
          CompanyData.office['latitude'], CompanyData.office['longitude'], position.latitude, position.longitude);

      await updatePosition(position, address);

      // print(placemarks[0]);

      DateTime now = DateTime.now();
      String jamString = DateFormat.Hms().format(now).split(':').first;
      var jam = int.parse(jamString);

      if (distance <= 15) {
        await processPresence(position, address, distance);
      } else {
        CustomToast.errorToast("Error", "Pastikan anda berada di wilayah kantor Desa Mekarjaya");
      }

      isLoading.value = false;
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi kesalahan", determinePosition["message"]);
    }
  }

  firstPresence(
    CollectionReference<Map<String, dynamic>> presenceCollection,
    String todayDocId,
    Position position,
    String address,
    double distance,
    bool inArea,
    String jam,
    String hari,
    String keterangan,
  ) async {
    CustomAlertDialog.showPresenceAlert(
      title: "Apakah anda ingin absen masuk?",
      message: "Anda perlu mengkonfirmasi sebelum Anda melakukan kehadiran sekarang",
      onCancel: () => Get.back(),
      onConfirm: () async {
        await presenceCollection.doc(todayDocId).set(
          {
            "tanggal": DateTime.now().toIso8601String(),
            "masuk": {
              "tanggal": DateTime.now().toIso8601String(),
              "jam": jam,
              "hari": hari,
              "latitude": position.latitude,
              "longitude": position.longitude,
              "lokasi": address,
              "in_area": inArea,
              "jarak": distance.toStringAsFixed(2),
              "keterangan": keterangan
            }
          },
        );
        Get.back();
        CustomToast.successToast("Berhasil", "Berhasil absen masuk");
      },
    );
  }

  checkinPresence(
    CollectionReference<Map<String, dynamic>> presenceCollection,
    String todayDocId,
    Position position,
    String address,
    double distance,
    bool inArea,
    String jam,
    String hari,
    String keterangan,
  ) async {
    CustomAlertDialog.showPresenceAlert(
      title: "Apakah anda ingin absen masuk?",
      message: "Anda perlu mengkonfirmasi sebelum Anda melakukan kehadiran sekarang",
      onCancel: () => Get.back(),
      onConfirm: () async {
        await presenceCollection.doc(todayDocId).set(
          {
            "tanggal": DateTime.now().toIso8601String(),
            "masuk": {
              "tanggal": DateTime.now().toIso8601String(),
              "jam": jam,
              "hari": hari,
              "latitude": position.latitude,
              "longitude": position.longitude,
              "lokasi": address,
              "in_area": inArea,
              "jarak": distance.toStringAsFixed(2),
              "keterangan": keterangan
            }
          },
        );
        Get.back();
        CustomToast.successToast("Berhasil", "Berhasil absen masuk");
      },
    );
  }

  checkoutPresence(
    CollectionReference<Map<String, dynamic>> presenceCollection,
    String todayDocId,
    Position position,
    String address,
    double distance,
    bool inArea,
    String jam,
    String hari,
  ) async {
    CustomAlertDialog.showPresenceAlert(
      title: "Apakah anda ingin absen keluar?",
      message: "Anda perlu mengkonfirmasi sebelum Anda melakukan kehadiran sekarang",
      onCancel: () => Get.back(),
      onConfirm: () async {
        await presenceCollection.doc(todayDocId).update(
          {
            "keluar": {
              "tanggal": DateTime.now().toIso8601String(),
              "jam": jam,
              "hari": hari,
              "latitude": position.latitude,
              "longitude": position.longitude,
              "lokasi": address,
              "in_area": inArea,
              "jarak": distance.toStringAsFixed(2),
            }
          },
        );
        Get.back();
        CustomToast.successToast("Berhasil", "Berhasil absen keluar");
      },
    );
  }

  Future<void> processPresence(Position position, String address, double distance) async {
    String uid = auth.currentUser!.uid;
    DateTime now = DateTime.now();
    String jam = DateFormat.Hms().format(now);
    String hari = DateFormat.yMMMMEEEEd('id_ID').format(now);
    String todayDocId = DateFormat.yMd().format(now).replaceAll('/', '-');

    String jamStr = DateFormat.Hms().format(now).split(':').first;
    var jamSekarang = int.parse(jamStr);

    CollectionReference<Map<String, dynamic>> presenceCollection =
        firestore.collection("pegawai").doc(uid).collection("presensi");
    QuerySnapshot<Map<String, dynamic>> snapshotPreference = await presenceCollection.get();

    bool inArea = false;
    if (distance <= 20) {
      inArea = true;
    }

    String keterangan = 'Telat';
    if (jamSekarang <= 8) {
      keterangan = 'Tepat Waktu';
    }

    if (snapshotPreference.docs.isEmpty) {
      //? :  tidak pernah ada -> setel cek di kehadiran
      firstPresence(presenceCollection, todayDocId, position, address, distance, inArea, jam, hari, keterangan);
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
            checkoutPresence(presenceCollection, todayDocId, position, address, distance, inArea, jam, hari);
          } else {
            CustomToast.errorToast("Error", "Anda hanya bisa absen keluar pada jam 13:00 - 14:30");
          }
        }
      } else {
        // ? : belum absen masuk hari ini
        checkinPresence(presenceCollection, todayDocId, position, address, distance, inArea, jam, hari, keterangan);
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;
    await firestore.collection("pegawai").doc(uid).update({
      "posisi": {
        "latitude": position.latitude,
        "longitude": position.longitude,
      },
      "lokasi": address,
    });
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        'message': 'Layanan lokasi dinonaktifkan, mohon hidupkan lokasi.',
        'error': true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "message": "Tidak dapat mengakses karena anda menolak permintaan lokasi",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message": "Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.",
        "error": true,
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false,
    };
  }
}
