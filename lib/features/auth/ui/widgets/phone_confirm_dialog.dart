import 'package:flutter/material.dart';
import 'package:lije/core/l10n/strings.dart';
import 'package:lije/core/theme/colors.dart';
import 'package:lije/features/auth/models/auth_user.dart';

/// Shows a dialog asking the user to confirm their phone number before auth.
Future<bool> showPhoneConfirmDialog(
  BuildContext context, {
  required AppLang lang,
  required String phone,
  required Carrier carrier,
}) async {
  final formatted = '${carrier.dialCode} $phone';
  final result = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(
        LS.get(lang, 'authPhoneConfirmTitle'),
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: C.darkBlue,
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LS.get(lang, 'authPhoneConfirmBody'),
            style: const TextStyle(
              fontSize: 14,
              color: C.textLight,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: C.lightBlue,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: C.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  carrier.displayName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: C.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatted,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: C.darkBlue,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(false),
          child: Text(
            LS.get(lang, 'cancel'),
            style: const TextStyle(color: C.textLight, fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(true),
          child: Text(
            LS.get(lang, 'authPhoneConfirmYes'),
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
