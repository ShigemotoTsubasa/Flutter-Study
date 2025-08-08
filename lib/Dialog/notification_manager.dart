import 'package:flutter/material.dart';

class NotificationManager {
  static void showError(String errorMessage, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  }
}
