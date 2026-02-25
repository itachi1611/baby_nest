import 'package:flutter/material.dart';
import 'package:fx_flame/extensions/widget_extension.dart';
import 'package:gap/gap.dart';

import '../common/app_enums.dart' show SnackBarType;

extension ContextExtension on BuildContext {
  /// Action - show SnackBar
  void showSnackBar({
    required String message,
    SnackBarType type = SnackBarType.info,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
  }) {
    assert(
      (onAction != null && actionLabel != null) || (onAction == null && actionLabel == null),
      'If onAction is provided, actionLabel must be provided and vice versa.',
    );

    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 2,
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 10.0,
      ),
      showCloseIcon: true,
      closeIconColor: type.color,
      behavior: SnackBarBehavior.fixed,
      duration: duration,
      backgroundColor: type.bgColor,
      content: Row(
        children: [
          Icon(type.icon, color: type.color),
          const Gap(10),
          Text(message, style: TextStyle(color: type.color, fontWeight: FontWeight.w600)).expand
        ],
      ),
      action: onAction != null
          ? SnackBarAction(label: actionLabel!, onPressed: () => onAction.call(), textColor: type.color)
          : null,
    );

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void get hideSnackBar => ScaffoldMessenger.of(this).hideCurrentSnackBar();
}
