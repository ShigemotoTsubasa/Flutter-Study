import 'dart:developer';

import 'package:flutter/material.dart';

class NotificationManager {
  void showError(String errorMessage, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  }
}
