/// Deterministically derives a user id by fusing the phone number and name.
String generateUserId(String phone, String name) {
  final normalized = '$phone:${name.trim().toLowerCase()}';
  int hash = 0;
  for (final unit in normalized.codeUnits) {
    hash = 0x1fffffff & (hash + unit);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    hash ^= (hash >> 6);
  }
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash ^= (hash >> 11);
  hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  return 'U${hash.toRadixString(16)}';
}
