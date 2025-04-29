import 'package:flutter/material.dart';

abstract class NotificationService {
  void showSnackBar({
    required BuildContext context,
    required String message,
    Function()? undoAction,
    String? undoLabel,
    Duration duration,
  });

  Future<void> showSuccessAlert({
    required BuildContext context,
    required String title,
    required String content,
    Function()? confirmCallback,
  });

  Future<void> showQuestionAlert({
    required BuildContext context,
    required String title,
    required String content,
    Function() confirmCallback,
    Function() cancelCallback,
  });
}