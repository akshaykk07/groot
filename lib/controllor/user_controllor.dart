import 'dart:developer';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class GetuserData extends GetxController {
  RxString id = "".obs;
  RxString user_name = "".obs;
  RxString user_image = "".obs;
  @override
  void onInit() {
    getUservalue();
    log("Get User Data completed");
    super.onInit();
  }

  getUservalue() async {
    try {
      SharedPreferences userData = await SharedPreferences.getInstance();
      id.value = userData.getString('user_id') ?? "";
      user_name.value = userData.getString('user_name') ?? "";
      user_image.value = userData.getString('user_image') ?? "";
    } catch (e) {}
  }
}
