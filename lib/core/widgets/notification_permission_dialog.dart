import 'package:flutter/material.dart';
import 'package:lije/core/l10n/strings.dart';
import 'package:lije/core/theme/colors.dart';

/// In-app rationale shown before the OS notification permission sheet.
Future<bool> showNotificationPermissionDialog(
  BuildContext context,
  AppLang lang,
) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: C.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_active_rounded,
                color: C.darkBlue, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              LS.get(lang, 'notifyPermTitle'),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: C.darkBlue,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        LS.get(lang, 'notifyPermBody'),
        style: const TextStyle(
          fontSize: 14,
          color: C.textLight,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            LS.get(lang, 'notifyPermLater'),
            style: const TextStyle(
              color: C.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            LS.get(lang, 'notifyPermAllow'),
            style: const TextStyle(
              color: C.darkBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
