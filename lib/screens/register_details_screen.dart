import 'package:flutter/material.dart';
import 'package:task1/constants/colors.dart';
import 'package:task1/constants/string.dart';
import '../utils/methods.dart';
import '../widgets/button.dart';

class RegisterDetailsScreen extends StatefulWidget {
  const RegisterDetailsScreen({super.key});

  @override
  State<RegisterDetailsScreen> createState() => _RegisterDetailsScreenState();
}

class _RegisterDetailsScreenState extends State<RegisterDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? _validateInput(String? input, int index) {
    if (input != null) {
      input = input.trim();
    }

    switch (index) {
      case 0:
        if (input == null || input.isEmpty) {
          return 'Field empty';
        } else if (input.length < 2) {
          return 'First name is too short';
        } else if (input.length > 40) {
          return 'First name is too long';
        }
        break;

      case 1:
        if (input == null || input.isEmpty) {
          return 'Field empty';
        } else if (input.length < 2) {
          return 'Last name is too short';
        } else if (input.length > 40) {
          return 'Last name is too long';
        }
        break;

      case 2:
        if (input == null || input.isEmpty) {
          return 'Field empty';
        } else if (input.length < 2) {
          return 'Village name is too short';
        } else if (input.length > 40) {
          return 'Village name is too long';
        }
        break;

      case 3:
        if (input == null || input.isEmpty) {
          return 'Field empty';
        } else if (!isNumeric(input) || input.length != 6) {
          return 'Pin code is invalid';
        }
        break;

      case 4:
        if (input == null || input.isEmpty) {
          return 'Field empty';
        } else if (input.length < 4) {
          return 'Address is too short';
        } else if (input.length > 200) {
          return 'Address is too long';
        }
        break;

      default:
        return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        title: const Text(StringValue.register),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: ((value) {
                        return _validateInput(value, 0);
                      }),
                      controller: firstnameController,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'First name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: ((value) {
                        return _validateInput(value, 1);
                      }),
                      controller: lastnameController,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'Last name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: ((value) {
                        return _validateInput(value, 2);
                      }),
                      controller: villageController,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'Village',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: ((value) {
                        return _validateInput(value, 3);
                      }),
                      controller: pincodeController,
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'Pin code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: ((value) {
                  return _validateInput(value, 4);
                }),
                controller: addressController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Button(
                    color: secondaryColor,
                    label: 'NEXT',
                    onPressed: () {
                      bool isValid = _formKey.currentState!.validate();
                      if (isValid) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomeScreen()));
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
