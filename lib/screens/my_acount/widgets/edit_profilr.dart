import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task1/constants/colors.dart';
import 'package:task1/constants/string.dart';
import 'package:task1/model/user_model.dart';
import 'package:task1/utils/my_acount_utils.dart';

class EditProfile extends StatefulWidget {
  final User userData;
  final String token;

  const EditProfile({Key? key, required this.userData, required this.token})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final MyAcoutMethode myAcountMoth = Get.put(MyAcoutMethode());
  late TextEditingController fullNameController;
  late TextEditingController stateController;
  late TextEditingController districtController;
  late TextEditingController tehsilController;
  late TextEditingController villageController;
  late TextEditingController pinCodeController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.userData.name);
    stateController = TextEditingController(text: widget.userData.state);
    districtController = TextEditingController(text: widget.userData.district);
    tehsilController = TextEditingController(text: widget.userData.tehsil);
    villageController = TextEditingController(text: widget.userData.village);
    pinCodeController = TextEditingController(text: widget.userData.pincode);
    addressController = TextEditingController(text: widget.userData.address);
  }

  // Move the buildTextField function here.
  Widget buildTextField(
      {required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
      ),
    );
  }

  void updateProfile(id, token) {
    String fullName = fullNameController.text;
    String state = stateController.text;
    String district = districtController.text;
    String tehsil = tehsilController.text;
    String village = villageController.text;
    String pinCode = pinCodeController.text;
    String address = addressController.text;

    myAcountMoth.updateProfile(
      userId: id,
      name: fullName,
      email: "aman@gmail.com",
      password: "123456",
      state: state,
      district: district,
      tehsil: tehsil,
      village: village,
      pincode: pinCode,
      address: address,
      token: token,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(StringValue.editProfile),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField(
                controller: fullNameController, label: StringValue.fullName),
            buildTextField(
                controller: stateController, label: StringValue.state),
            buildTextField(
                controller: districtController, label: StringValue.district),
            buildTextField(
                controller: tehsilController, label: StringValue.tehsil),
            buildTextField(
                controller: villageController, label: StringValue.village),
            buildTextField(
                controller: pinCodeController, label: StringValue.pinCode),
            buildTextField(
                controller: addressController, label: StringValue.uAddress),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  updateProfile(widget.userData.id, widget.token);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                ),
                child: const Text(
                  StringValue.update,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
