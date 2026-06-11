import 'package:shared_preferences/shared_preferences.dart';
import 'package:lije/features/auth/models/auth_user.dart';

/// Persists the locally-authenticated user.
class AuthStorage {
  static const _userIdKey = 'auth_user_id';
  static const _nameKey = 'auth_name';
  static const _phoneKey = 'auth_phone';
  static const _carrierKey = 'auth_carrier';

  static Future<AuthUser?> loadUser() async {
    final p = await SharedPreferences.getInstance();
    final userId = p.getString(_userIdKey);
    final name = p.getString(_nameKey);
    final phone = p.getString(_phoneKey);
    final carrierName = p.getString(_carrierKey);
    if (userId == null || name == null || phone == null || carrierName == null) {
      return null;
    }
    return AuthUser(
      userId: userId,
      name: name,
      phone: phone,
      carrier: Carrier.values.byName(carrierName),
    );
  }

  static Future<void> saveUser(AuthUser user) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_userIdKey, user.userId);
    await p.setString(_nameKey, user.name);
    await p.setString(_phoneKey, user.phone);
    await p.setString(_carrierKey, user.carrier.name);
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_userIdKey);
    await p.remove(_nameKey);
    await p.remove(_phoneKey);
    await p.remove(_carrierKey);
  }
}
