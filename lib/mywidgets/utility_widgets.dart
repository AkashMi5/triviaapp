import 'package:flutter/material.dart';

class UtilityWidgets {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          message,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        )));
  }
}
