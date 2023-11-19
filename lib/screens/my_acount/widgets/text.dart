import 'package:flutter/material.dart';

class TextWidgets {
  static Widget TextW(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(fontSize: 17),
        ),
        const Divider(thickness: 1),
        const SizedBox(height: 8),
      ],
    );
  }
}
