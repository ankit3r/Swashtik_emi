import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task1/api/responce_repo.dart';
import 'package:task1/constants/colors.dart';
import 'package:task1/constants/string.dart';
import 'package:task1/screens/my_acount/widgets/action_widget.dart';
import 'package:task1/screens/my_acount/widgets/profileUi.dart';
import 'package:task1/utils/my_acount_utils.dart';

class MyAccount extends StatefulWidget {
  final LoginResponse? user;
  const MyAccount({Key? key, required this.user}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final MyAcoutMethode myAcountMoth = Get.put(MyAcoutMethode());
  @override
  void initState() {
    super.initState();
    myAcountMoth.isLogout.value
        ? myAcountMoth.fetchData(widget.user)
        : myAcountMoth.userData.value == null
            ? myAcountMoth.fetchData(widget.user)
            : myAcountMoth.isLoding.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyColor,
      appBar: AppBar(
        backgroundColor: lightGreyColor,
        elevation: 0,
        title: const Text(StringValue.myAccount),
        actions: [ActionButton(user: widget.user)],
      ),
      body: Obx(
        () {
          return myAcountMoth.isLoding.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : myAcountMoth.userData.value == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Failed to load data"),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () {
                                myAcountMoth.fetchData(widget.user);
                              },
                              child: const Text("Retry"))
                        ],
                      ),
                    )
                  : ProfileUi(
                      userData: myAcountMoth.userData.value!,
                      token: widget.user!.token,
                    );
        },
      ),
    );
  }
}
