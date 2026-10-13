import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/theme.dart';

class UIHelper {
  UIHelper._();

  static Future<dynamic> showCustomBottomSheet({required Widget bottomSheet}) => showModalBottomSheet(
        context: Get.context!,
        isDismissible: true,
        isScrollControlled: true,
        barrierColor: const Color(0xFF141414).withValues(alpha: 0.9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => bottomSheet,
      );

  static void showCustomSnackBar({
    required String title,
    required Color titleColor,
    required Color backgroundColor,
    Widget? actionButton,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: backgroundColor,
        borderRadius: 100,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.not_interested_rounded),
        messageText: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.poppins3.copyWith(color: titleColor),
              ),
            ),
            actionButton ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
