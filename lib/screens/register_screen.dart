import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task1/constants/colors.dart';
import 'package:task1/constants/string.dart';

import '../api/api_controller.dart';
import '../widgets/button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ApiController apiController = Get.put(ApiController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void pop() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        title: const Text(StringValue.register),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(StringValue.appLogo, height: 200),
              const Text(
                StringValue.appName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return StringValue.nameRequired;
                        } else if (value.length < 2) {
                          return StringValue.nameLength;
                        }
                        return null;
                      },
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: StringValue.name,
                        labelText: StringValue.yourName,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
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
                    const SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: passwordController,
                      obscureText: true,
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
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Button(
                    color: secondaryColor,
                    label: StringValue.register,
                    onPressed: () async {
                      bool isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        bool isSuccess = await apiController.registerUser(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                        );
                        if (isSuccess) {
                          pop();
                        }
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
