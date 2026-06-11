import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import 'package:lije/features/auth/models/auth_user.dart';

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

  /// Returns the Supabase client, or `null` if Supabase has not been
  /// initialized (e.g. missing --dart-define credentials) or is otherwise
  /// unreachable.
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

  /// Registers [user] with Supabase (insert into `users`), then caches the
  /// result locally so the app keeps working offline.
  ///
  /// Throws [AuthException] with:
  /// - `"phone already registered"` if the phone already exists remotely.
  /// - `"network error"` if Supabase could not be reached.
  ///
  /// If Supabase is not configured at all, the user is saved locally only
  /// (offline-first fallback).
  static Future<AuthUser> signUp(AuthUser user) async {
    final client = _client;
    if (client == null) {
      await saveUser(user);
      return user;
    }

    try {
      final existing = await client
          .from(_table)
          .select('id')
          .eq('phone', user.phone)
          .maybeSingle();

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

      final saved = user.copyWith(supabaseId: inserted['id'] as String);
      await saveUser(saved);
      return saved;
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('network error');
    }
  }

  /// Looks up a user by phone number in Supabase.
  ///
  /// On success, the remote record is cached locally and returned.
  ///
  /// Throws [AuthException] with:
  /// - `"no account found"` if no row matches [phone] remotely.
  /// - `"network error"` if Supabase could not be reached and no matching
  ///   user is cached locally for offline use.
  ///
  /// If Supabase is not configured at all, falls back to the locally
  /// cached user (matched by name, phone and carrier).
  static Future<AuthUser> logIn({
    required String name,
    required String phone,
    required Carrier carrier,
  }) async {
    final client = _client;
    if (client == null) {
      return _logInFromCache(name: name, phone: phone, carrier: carrier);
    }

    try {
      final row =
          await client.from(_table).select().eq('phone', phone).maybeSingle();

      if (row == null) {
        throw const AuthException('no account found');
      }

      final user = AuthUser(
        userId: row['id'] as String,
        name: row['name'] as String? ?? name,
        phone: row['phone'] as String? ?? phone,
        carrier: Carrier.values.byName(row['carrier'] as String? ?? carrier.name),
        supabaseId: row['id'] as String,
      );
      await saveUser(user);
      return user;
    } on AuthException catch (e) {
      if (e.message == 'no account found') rethrow;
      return _logInFromCache(name: name, phone: phone, carrier: carrier);
    } catch (_) {
      // Network failure: fall back to the locally cached user so the app
      // keeps working offline after the first successful login.
      return _logInFromCache(name: name, phone: phone, carrier: carrier);
    }
  }

  static Future<AuthUser> _logInFromCache({
    required String name,
    required String phone,
    required Carrier carrier,
  }) async {
    final cached = await loadUser();
    final matches = cached != null &&
        cached.phone == phone &&
        cached.carrier == carrier &&
        cached.name.toLowerCase() == name.toLowerCase();
    if (!matches) {
      throw const AuthException('no account found');
    }
    return cached;
  }
}
