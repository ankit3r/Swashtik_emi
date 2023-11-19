import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:task1/api/responce_repo.dart';
import '../model/data_model.dart';
import '../model/user_model.dart';

class ApiController extends GetxController {
  RxString vConfirmCount = "0".obs;
  RxBool isLoading = false.obs;

  // user register api

  Future<bool> registerUser(String name, String email, String password) async {
    if (await _isInternetAvailable()) {
      progress("Register", "Data Uploading...");
      try {
        var url = Uri.parse('https://mcq.codingbandar.com/api/users/register');
        var request = http.MultipartRequest('POST', url)
          ..fields['name'] = name
          ..fields['email'] = email
          ..fields['password'] = password;

        http.StreamedResponse response = await request.send();
        Get.back();
        if (response.statusCode == 201) {
          var jsonResponse = json.decode(await response.stream.bytesToString());
          showSnackBar("Register...", jsonResponse['message'], null);
          return true;
        } else {
          var jsonResponse = json.decode(await response.stream.bytesToString());
          showSnackBar("Register...", jsonResponse['message'], Colors.red);
          return false;
        }
      } catch (e) {
        handleError(e, 'Failed to register user');
        return false;
      }
    } else {
      showToast("Connection", "No internet connection", Colors.red);
      return false;
    }
  }

// user login api
  Future<LoginResponse?> loginUser(String email, String password) async {
    if (await _isInternetAvailable()) {
      progress("Login", "Loading Data...");
      var url = Uri.parse('https://mcq.codingbandar.com/api/users/login');
      var response = await http.post(url, body: {
        'email': email,
        'password': password,
      });
      Get.back();
      var jsonResponse = json.decode(response.body);
      showSnackBar("Login...", jsonResponse['message'], null);
      var userData = jsonResponse['user'];
      var user = User.fromJson(userData);

      if (response.statusCode == 200) {
        return LoginResponse(jsonResponse['token'], true, user);
      } else {
        return LoginResponse("", false, null);
      }
    } else {
      showToast("Connection", "No internet connection", Colors.red);
      return null;
    }
  }

// get user profile by token and user id
  Future<User?> getProfile(String token, String userId) async {
    if (await _isInternetAvailable()) {
      try {
        var url =
            Uri.parse('https://mcq.codingbandar.com/api/users/$userId/profile');
        var response =
            await http.get(url, headers: {'Authorization': 'Bearer $token'});
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          var user = User.fromJson(jsonResponse);
          return user;
        } else {
          showToast("Data", "Failed to loard data.", Colors.red);
          return null;
        }
      } catch (e) {
        showToast("Data", "Error during API call", Colors.red);
        return null;
      }
    } else {
      showToast("Connection", "No internet connection", Colors.red);
      return null;
    }
  }

// update profile pic
  Future<void> updateProfilePicture(
    String userId,
    String token,
    XFile imageUri,
  ) async {
    if (await _isInternetAvailable()) {
      try {
        var url = Uri.parse(
            'https://mcq.codingbandar.com/api/users/$userId/profile-picture');

        var request = http.MultipartRequest('POST', url);
        request.headers['Authorization'] = 'Bearer $token';

        var stream = http.ByteStream(imageUri.openRead());
        var length = await imageUri.length();
        var multipartFile = http.MultipartFile('image', stream, length,
            filename: imageUri.path);

        request.files.add(multipartFile);
        progress("Profile Pic", "updating...");

        var response = await request.send();

        Get.back();
        if (response.statusCode == 200) {
          showToast("Profile Pic", 'Profile picture updated successfully',
              Colors.green);
        } else {
          showToast(
              "Profile Pic", 'Failed to update profile picture.', Colors.red);
        }
      } catch (e) {
        handleError(e, 'Failed to update profile picture.');
      }
    } else {
      showToast("Connection", "No internet connection", Colors.red);
    }
  }

// loan data api
  Future<List<DataModel>> getData(String token) async {
    if (await _isInternetAvailable()) {
      var url = Uri.parse('https://mcq.codingbandar.com/api/api/data/approved');
      try {
        var response =
            await http.get(url, headers: {'Authorization': 'Bearer $token'});

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          List<dynamic> dataList = jsonResponse[0]["data"];
          List<DataModel> dataModelList =
              dataList.map((data) => DataModel.fromJson(data)).toList();
          return dataModelList;
        } else {
          showToast("Data", "Failed to get profile. Error", Colors.red);

          return [];
        }
      } catch (e) {
        showToast("Data", "Error during API call", Colors.red);

        return [];
      }
    } else {
      showToast("Connection", "No internet connection", Colors.red);
      return [];
    }
  }

// search queary api
  Future<List<DataModel>> searchQuery(String token, String query) async {
    if (await _isInternetAvailable()) {
      var url = Uri.parse(
          'https://mcq.codingbandar.com/api/api/data/search?query=$query');
      try {
        var response =
            await http.get(url, headers: {'Authorization': 'Bearer $token'});
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          List<dynamic> dataList = jsonResponse[0]["data"];
          List<DataModel> dataModelList =
              dataList.map((data) => DataModel.fromJson(data)).toList();
          return dataModelList;
        } else {
          showToast("Search", "Failed to get search query", Colors.red);
          return [];
        }
      } catch (e) {
        showToast("Data", "Error during API call", Colors.red);
        return [];
      }
    } else {
      showToast("Connection", "No internet connection", Colors.red);
      return [];
    }
  }

// status confirm and calcel
  Future<void> updateDataStatus(
      String token, int dataId, int userId, String status) async {
    if (await _isInternetAvailable()) {
      progress("Status", "$status updating...");
      try {
        var url = Uri.parse(
            'https://mcq.codingbandar.com/api/datastatus/$dataId/$userId');
        var response = await http.post(url,
            headers: {'Authorization': 'Bearer $token'},
            body: {'status': status});

        if (response.statusCode == 201) {
          Get.back();
          var jsonResponse = json.decode(response.body);
          showToast(status, jsonResponse['message'], Colors.green);
        } else {
          Get.back();
          showToast(status, "failed to $status.", Colors.red);
        }
      } catch (e) {
        Get.back();
        handleError(e, 'Failed to update Status');
      }
    } else {
      showToast("Connection", "No internet connection", Colors.red);
    }
  }

// get a confirm data count
  Future<void> getConfirmStatusCount(String token, int userId) async {
    final String apiUrl =
        "https://mcq.codingbandar.com/api/users/status/$userId/confirm";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);
        var count = jsonResponse['count'];
        vConfirmCount.value = count.toString();
      } else {
        showToast("V conirem Data", "Failed to load", Colors.red);
      }
    } catch (e) {
      showToast("V conirem Data", "Failed to load 2", Colors.red);
      print("Error $e");
    }
  }

  // snackbar
  void showSnackBar(String title, String message, Color? color) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color ?? Colors.white);
  }

  // show toast
  void showToast(String title, String message, Color color) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: color);
  }

// progress diloge
  void progress(String title, String discription) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title),
              const SizedBox(height: 26),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(discription),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

// update prfile
  Future<void> updateProfile({
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
    try {
      final String apiUrl =
          "https://mcq.codingbandar.com/api/users/$userId/profile";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'name': name,
          'email': email,
          'password': password,
          'state': state,
          'district': district,
          'tehsil': tehsil,
          'village': village,
          'pincode': pincode,
          'address': address,
        },
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Profile updated successfully');
      } else {
        // Handle failure
        print('Failed to update profile');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception while updating profile: $e');
    }
  }

// error handleing
  void handleError(dynamic error, String message) {
    if (error is NetworkException) {
      // Handle network issues
      showRetryDialog(message, retryFunction: () {
        // Retry the operation
      });
    } else {
      // Handle other types of errors
      showToast('Error', message, Colors.red);
    }
  }

  // Display a dialog with retry and cancel options
  Future<void> showRetryDialog(String message,
      {Function? retryFunction}) async {
    return Get.defaultDialog(
      title: 'Error',
      middleText: message,
      textConfirm: 'Retry',
      textCancel: 'Cancel',
      onConfirm: () {
        if (retryFunction != null) {
          retryFunction();
        }
      },
      onCancel: () {
        // Handle cancel action
      },
    );
  }

// checking internate conection
  Future<bool> _isInternetAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}
