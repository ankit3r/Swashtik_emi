import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/api/responce_repo.dart';
import 'package:task1/screens/home_screen.dart';
import 'package:task1/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool rememberMe = prefs.getBool('rememberMe') ?? false;
  LoginResponse? loginResponse;
  if (rememberMe) {
    String? loginResponseString = prefs.getString('loginResponse');
    if (loginResponseString != null) {
      Map<String, dynamic> loginResponseMap = json.decode(loginResponseString);
      loginResponse = LoginResponse.fromJson(loginResponseMap);
    }
  }

  runApp(MyApp(loginResponse: loginResponse));
}

class MyApp extends StatelessWidget {
  final LoginResponse? loginResponse;
  const MyApp({Key? key, this.loginResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swashtik Emi',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: loginResponse != null
          ? HomeScreen(user: loginResponse)
          : const LoginScreen(),
    );
  }
}
