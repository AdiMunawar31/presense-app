import 'package:get/get.dart';
import 'package:d2ypresence/app/controllers/presence_controller.dart';
import 'package:d2ypresence/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  final presenceController = Get.find<PresenceController>();
  RxInt pageIndex = 0.obs;
  String? message = "";

  void changePage(int index) async {
    pageIndex.value = index;
    switch (index) {
      case 1:
        presenceController.presence();
        break;
      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
        break;
    }
  }
}
