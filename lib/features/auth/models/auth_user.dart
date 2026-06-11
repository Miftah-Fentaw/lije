/// Mobile network carriers supported for sign up / login.
enum Carrier { ethiotelecom, safaricom }

extension CarrierInfo on Carrier {
  String get displayName {
    switch (this) {
      case Carrier.ethiotelecom:
        return 'Ethio Telecom';
      case Carrier.safaricom:
        return 'Safaricom';
    }
  }

  /// Short network code shown in the carrier picker.
  String get shortName {
    switch (this) {
      case Carrier.ethiotelecom:
        return 'ETH';
      case Carrier.safaricom:
        return 'SFR';
    }
  }

  /// Country dial code shared by both networks.
  String get dialCode => '+251';

  /// Valid leading digit for local subscriber numbers on this network.
  String get prefix {
    switch (this) {
      case Carrier.ethiotelecom:
        return '9';
      case Carrier.safaricom:
        return '7';
    }
  }
}

/// A locally-authenticated user identified by phone number + name.
class AuthUser {
  final String userId;
  final String name;
  final String phone;
  final Carrier carrier;

  const AuthUser({
    required this.userId,
    required this.name,
    required this.phone,
    required this.carrier,
  });

  String get fullPhone => '${carrier.dialCode}$phone';
}
