import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/api/responce_repo.dart';
import 'package:task1/constants/colors.dart';
import 'package:task1/constants/string.dart';
import 'package:task1/screens/home_screen.dart';
import 'package:task1/screens/register_screen.dart';
import 'package:task1/widgets/button.dart';

import '../api/api_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiController apiController = Get.put(ApiController());
  String countryCode = "+91";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', true);
  }

  void _saveLoginResponse(LoginResponse loginResponse) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loginResponse', json.encode(loginResponse.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    void navToHome(LoginResponse user) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                StringValue.appLogo,
                height: 200,
              ),
              const Text(StringValue.appName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.phone, color: secondaryColor),
                SizedBox(
                  width: 4,
                ),
                Text(
                  StringValue.contactNo,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                )
              ]),
              const SizedBox(
                height: 10,
              ),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.location_pin, color: secondaryColor),
                SizedBox(
                  width: 4,
                ),
                Text(
                  StringValue.address,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                )
              ]),
              const SizedBox(
                height: 40,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return StringValue.emailRequired;
                        } else if (!GetUtils.isEmail(value)) {
                          return StringValue.emailInvalid;
                        }
                        return null;
                      },
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: StringValue.email,
                        labelText: StringValue.yourEmail,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return StringValue.passwordRequired;
                        } else if (value.length < 6) {
                          return StringValue.passwordLength;
                        }
                        return null;
                      },
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: StringValue.password,
                        labelText: StringValue.yourPassword,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Button(
                        color: secondaryColor,
                        label: StringValue.login,
                        onPressed: () async {
                          bool isValid = _formKey.currentState!.validate();
                          if (isValid) {
                            LoginResponse? user = await apiController.loginUser(
                              emailController.text,
                              passwordController.text,
                            );

                            if (user!.isSuccess) {
                              _saveUser();
                              _saveLoginResponse(user);
                              navToHome(user);
                            }
                          }
                        }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Button(
                        color: greyColor,
                        label: StringValue.register,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                        }),
                  )
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                StringValue.mobileDeviceChange,
                style: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              const Text(
                StringValue.aboutSoftware,
                style: TextStyle(color: greyColor, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const Text(
                StringValue.appVersion,
                style: TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const Text(
                StringValue.designBy,
                style: TextStyle(color: secondaryColor, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const Text(
                StringValue.designByName,
                style: TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                StringValue.purchaseContactNo,
                style: TextStyle(
                    color: secondaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
