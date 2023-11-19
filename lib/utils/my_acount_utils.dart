import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/api/api_controller.dart';
import 'package:task1/api/responce_repo.dart';
import 'package:task1/model/user_model.dart';

class MyAcoutMethode extends GetxController {
  final ApiController apiController = Get.put(ApiController());
  Rx<User?> userData = Rx<User?>(null);
  RxBool isLoding = true.obs;
  RxBool isLogout = false.obs;

  // logout finction
  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('rememberMe');
    await prefs.remove('loginResponse');
    isLogout.value = true;
  }

  // update profile pic
  void uploadProfile(LoginResponse? user) async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      if (user != null && user.currentUser != null) {
        final userId = user.currentUser!.id.toString();
        final token = user.token;
        await apiController.updateProfilePicture(userId, token, pickedImage);
        fetchData(user);
      } else {
        apiController.showToast(
            "Profile Pic", 'User data is not available', Colors.red);
      }
    } else {
      apiController.showToast("Profile Pic", 'No image selected', Colors.red);
    }
  }

  // get profile data
  void fetchData(LoginResponse? user) async {
    isLoding.value = true;

    userData.value = await apiController.getProfile(
        user!.token, user.currentUser!.id.toString());
    isLoding.value = false;
    isLogout.value = false;
  }

// update profile data

  void updateProfile({
    required String userId,
    required String name,
    required String email,
    required String password,
    required String state,
    required String district,
    required String tehsil,
    required String village,
    required String pincode,
    required String address,
    required String token,
  }) async {
    await apiController.updateProfile(
        userId: userId,
        name: name,
        email: email,
        password: password,
        state: state,
        district: district,
        tehsil: tehsil,
        village: village,
        pincode: pincode,
        address: address,
        token: token);
  }
}
