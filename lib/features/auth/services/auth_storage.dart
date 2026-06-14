import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import 'package:lije/features/auth/models/auth_user.dart';
import 'package:lije/features/auth/services/user_id_generator.dart';

/// Thrown by [AuthStorage.signUp] / [AuthStorage.logIn] with a
/// user-displayable message (e.g. "phone already registered",
/// "no account found").
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// Persists the locally-authenticated user and synchronizes it with the
/// Supabase `users` table (phone-number based, no OTP).
class AuthStorage {
  static const _userIdKey = 'auth_user_id';
  static const _nameKey = 'auth_name';
  static const _phoneKey = 'auth_phone';
  static const _carrierKey = 'auth_carrier';
  static const _supabaseIdKey = 'auth_supabase_id';

  static const _table = 'users';

  static SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static Future<AuthUser?> loadUser() async {
    final p = await SharedPreferences.getInstance();
    final userId = p.getString(_userIdKey);
    final name = p.getString(_nameKey);
    final phone = p.getString(_phoneKey);
    final carrierName = p.getString(_carrierKey);
    if (userId == null ||
        name == null ||
        phone == null ||
        carrierName == null) {
      return null;
    }
    return AuthUser(
      userId: userId,
      name: name,
      phone: phone,
      carrier: Carrier.values.byName(carrierName),
      supabaseId: p.getString(_supabaseIdKey),
    );
  }

  static Future<void> saveUser(AuthUser user) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_userIdKey, user.userId);
    await p.setString(_nameKey, user.name);
    await p.setString(_phoneKey, user.phone);
    await p.setString(_carrierKey, user.carrier.name);
    if (user.supabaseId != null) {
      await p.setString(_supabaseIdKey, user.supabaseId!);
    } else {
      await p.remove(_supabaseIdKey);
    }
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_userIdKey);
    await p.remove(_nameKey);
    await p.remove(_phoneKey);
    await p.remove(_carrierKey);
    await p.remove(_supabaseIdKey);
  }

  static Future<Map<String, dynamic>?> _findUserByPhone(
    SupabaseClient client,
    String phone,
  ) async {
    final candidates = {
      phone,
      '+251$phone',
      '251$phone',
      if (phone.startsWith('251')) phone.substring(3),
      if (phone.startsWith('+251')) phone.substring(4),
    };

    for (final candidate in candidates) {
      final row = await client
          .from(_table)
          .select()
          .eq('phone', candidate)
          .maybeSingle();
      if (row != null) return row;
    }
    return null;
  }

  static AuthUser _userFromRow(
    Map<String, dynamic> row, {
    required String fallbackPhone,
    required Carrier fallbackCarrier,
  }) {
    final name = row['name'] as String? ?? '';
    return AuthUser(
      userId: row['id']?.toString() ??
          generateUserId(fallbackPhone, name),
      name: name,
      phone: row['phone'] as String? ?? fallbackPhone,
      carrier: Carrier.values.byName(
        row['carrier'] as String? ?? fallbackCarrier.name,
      ),
      supabaseId: row['id']?.toString(),
    );
  }

  static Future<AuthUser> signUp(AuthUser user) async {
    final client = _client;
    if (client == null) {
      await saveUser(user);
      return user;
    }

    try {
      final existing = await _findUserByPhone(client, user.phone);
      if (existing != null) {
        throw const AuthException('phone already registered');
      }

      final inserted = await client
          .from(_table)
          .insert({
            'name': user.name,
            'phone': user.phone,
            'carrier': user.carrier.name,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('id')
          .single();

      final saved = user.copyWith(supabaseId: inserted['id']?.toString());
      await saveUser(saved);
      return saved;
    } on AuthException {
      rethrow;
    } catch (_) {
      // Supabase unreachable — save locally so auth still completes.
      await saveUser(user);
      return user;
    }
  }

  static Future<AuthUser> logIn({
    required String phone,
    required Carrier carrier,
  }) async {
    final client = _client;
    if (client == null) {
      return _logInFromCache(phone: phone, carrier: carrier);
    }

    try {
      final row = await _findUserByPhone(client, phone);
      if (row == null) {
        throw const AuthException('no account found');
      }

      final user = _userFromRow(
        row,
        fallbackPhone: phone,
        fallbackCarrier: carrier,
      );
      await saveUser(user);
      return user;
    } on AuthException catch (e) {
      if (e.message == 'no account found') rethrow;
      return _logInFromCache(phone: phone, carrier: carrier);
    } catch (_) {
      return _logInFromCache(phone: phone, carrier: carrier);
    }
  }

  static Future<AuthUser> _logInFromCache({
    required String phone,
    required Carrier carrier,
  }) async {
    final cached = await loadUser();
    if (cached == null) {
      throw const AuthException('no account found');
    }

    final cachedDigits = cached.phone.replaceAll(RegExp(r'\D'), '');
    final inputDigits = phone.replaceAll(RegExp(r'\D'), '');
    final phoneMatches = cachedDigits == inputDigits ||
        cached.phone == phone ||
        cachedDigits.endsWith(inputDigits) ||
        inputDigits.endsWith(cachedDigits);

    if (!phoneMatches || cached.carrier != carrier) {
      throw const AuthException('no account found');
    }
    return cached;
  }
}
