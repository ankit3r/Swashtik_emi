import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task1/api/responce_repo.dart';
import 'package:task1/screens/login_screen.dart';
import 'package:task1/utils/my_acount_utils.dart';

class ActionButton extends StatefulWidget {
  final LoginResponse? user;
  const ActionButton({super.key, required this.user});
  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  final MyAcoutMethode myAcountMoth = Get.put(MyAcoutMethode());

  void _handlePopupSelection(String choice) {
    switch (choice) {
      case 'Logout':
        myAcountMoth.logOut();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 'Change profile picture':
        myAcountMoth.uploadProfile(widget.user);
        break;
      default:
    }
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, IconData iconData) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            iconData,
            color: const Color(0xFF676767),
          ), // Icon on the left
          const SizedBox(width: 8.0), // Spacer
          Text(value, style: const TextStyle(color: Color(0xFF676767))), // Text
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: _handlePopupSelection,
      itemBuilder: (BuildContext context) {
        return [
          _buildPopupMenuItem('Change profile picture',
              Icons.account_circle), // Customized item with icon
          _buildPopupMenuItem(
              'Add KYC picture', Icons.add_card), // Customized item with icon
          _buildPopupMenuItem('Account transaction',
              Icons.currency_rupee_sharp), // Customized item with icon
          _buildPopupMenuItem(
              'Logout', Icons.logout), // Customized item with icon
          _buildPopupMenuItem('Download id card',
              Icons.card_membership), // Customized item with icon
          _buildPopupMenuItem('Add OR Code picture',
              Icons.add_card), // Customized item with icon
        ];
      },
    );
  }
}
