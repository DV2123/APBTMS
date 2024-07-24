import 'package:get/get.dart';

import 'package:bus_karo/controller/network_controller.dart';

class DependencyInjection {

  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}