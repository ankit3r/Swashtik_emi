import 'package:flutter/material.dart';
import 'package:task1/constants/colors.dart';
import 'package:task1/constants/string.dart';
import 'package:task1/model/user_model.dart';
import 'package:task1/screens/my_acount/widgets/edit_profilr.dart';
import 'package:task1/screens/my_acount/widgets/text.dart';
import 'package:task1/utils/subscription_helper.dart';

class ProfileUi extends StatelessWidget {
  final User userData;
  final String token;

  const ProfileUi({super.key, required this.userData, required this.token});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lightGreyColor,
                  border: Border.all(color: greyColor, width: 0.3)),
              child: CircleAvatar(
                backgroundImage: NetworkImage(userData.profile == null
                    ? StringValue.defaultProfilePic
                    : userData.profile!),
                radius: 60,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(5)),
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.all(14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  const Text(StringValue.acountInfo,
                      style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(
                            userData: userData,
                            token: token,
                          ),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Text(StringValue.editProfile),
                        SizedBox(width: 10),
                        Icon(Icons.edit)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextWidgets.TextW(StringValue.fullName, userData.name),
              TextWidgets.TextW(StringValue.registerEmail, userData.email),
              TextWidgets.TextW(StringValue.state, userData.state ?? "NA"),
              Row(
                children: [
                  Expanded(
                    child: TextWidgets.TextW(
                        StringValue.district, userData.district ?? "NA"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextWidgets.TextW(
                        StringValue.tehsil, userData.tehsil ?? "NA"),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextWidgets.TextW(
                        StringValue.village, userData.village ?? "NA"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextWidgets.TextW(
                        StringValue.pinCode, userData.pincode ?? "NA"),
                  ),
                ],
              ),
              TextWidgets.TextW(StringValue.uAddress, userData.address ?? "NA")
            ]),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(5)),
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.all(14),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(StringValue.activeSub, style: TextStyle(fontSize: 13)),
              const SizedBox(height: 20),
              TextWidgets.TextW(
                  StringValue.from, StringValue.subscriptionStartDate),
              TextWidgets.TextW(
                  StringValue.till, StringValue.subscriptionEndDate),
              TextWidgets.TextW(
                  StringValue.remainingDays,
                  "Rem Day : ${SubscriptionHelper.calculateRemainingDays(
                    StringValue.subscriptionEndDate,
                  )}"),
            ]),
          ),
          const SizedBox(height: 20),
          const Text(StringValue.myKyc),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
