import 'package:lije/core/l10n/strings.dart';

final _nameRegExp = RegExp(r'^[a-zA-Zሀ-፿ ]{2,}$');

class AuthValidators {
  static String? name(AppLang lang, String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return LS.get(lang, 'authNameRequired');
    if (!_nameRegExp.hasMatch(v)) return LS.get(lang, 'authNameInvalid');
    return null;
  }

  /// Validates the 8 digits the user enters after the prefilled network
  /// prefix (9 or 7).
  static String? phone(AppLang lang, String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return LS.get(lang, 'authPhoneRequired');
    if (v.length != 8) return LS.get(lang, 'authPhoneInvalidLength');
    return null;
  }
}
