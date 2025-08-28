import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:pacific_kode_practical/domain/models/user_Profile.dart';

class UserGetX extends GetxController {
  late final    SharedPreferences    prefs;
  var userProfile = UserProfile(
    name: '',
    age: 0,
    email: '',
    mobileNumber: '',
  ).obs;
  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  save(UserProfile profile) async {
    userProfile.value = profile;

    prefs.setString('my_profile', jsonEncode( userProfile.value.toMap()));
  }

  loadUser() async {

prefs = await SharedPreferences.getInstance();

final String? data =     prefs.getString('my_profile');
if (data != null) {
  UserProfile savedUserProfile = UserProfile.fromMap(jsonDecode(data));
  userProfile.value = savedUserProfile;
}

  }

}