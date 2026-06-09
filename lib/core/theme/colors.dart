import 'package:flutter/material.dart';

abstract class C {
  // ── Core 3-color palette ───────────────────────────────────────────────────
  static const darkBlue = Color(0xFF1B3A6B);
  static const lightBlue = Color(0xFFD6E8F7);
  static const white = Color(0xFFFFFFFF);

  // ── Derived tokens (mapped to core palette) ──────────────────────────────
  static const navy = darkBlue;
  static const deep = darkBlue;
  static const mid = darkBlue;
  static const bright = darkBlue;
  static const vivid = darkBlue;
  static const soft = darkBlue;
  static const pale = lightBlue;
  static const frost = lightBlue;

  // ── Semantic aliases ────────────────────────────────────────────────────────
  static const primary = darkBlue;
  static const primaryDark = darkBlue;
  static const primaryLight = lightBlue;
  static const bgPage = lightBlue;
  static const cardBg = white;
  static const cardBorder = lightBlue;

  // ── Text ─────────────────────────────────────────────────────────────────────
  static const textDark = darkBlue;
  static const textMid = darkBlue;
  static const textLight = Color(0xFF6B8CAE);
  static const textBody = darkBlue;

  // ── Legacy/Semantic mappings ────────────────────────────────────────────────
  static const primaryBg = frost;
  static const primaryBg2 = pale;
  static const offWhite = Color(0xFFF8FAFC);

  // ── Sky family (mapped to core palette) ─────────────────────────────────────
  static const skyDeep = darkBlue;
  static const skyMid = darkBlue;
  static const skyBright = darkBlue;
  static const skyLight = lightBlue;
  static const skyPale = lightBlue;
  static const skyFrost = lightBlue;
  static const skyGlow = lightBlue;

  // ── Semantic colours ─────────────────────────────────────────────────────────
  static const success = Color(0xFF10B981);
  static const successBg = Color(0xFFD1FAE5);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFFEEEE);
  static const warn = Color(0xFFF59E0B);
  static const warnBg = Color(0xFFFEF3C7);

  // ── Accent families ──────────────────────────────────────────────────────────
  static const coral = Color(0xFFF43F5E);
  static const coralLight = Color(0xFFFFF1F2);
  static const coralBg = Color(0xFFFFF1F2);
  static const gold = Color(0xFFF59E0B);
  static const goldLight = Color(0xFFFEF3C7);
  static const mint = Color(0xFF10B981);
  static const mintLight = Color(0xFFECFDF5);
  static const lavender = Color(0xFF8B5CF6);
  static const lavenderLight = Color(0xFFF5F3FF);
  static const purple = Color(0xFF8B5CF6);
  static const purpleBg = Color(0xFFF5F3FF);

  // ── Borders & surfaces ────────────────────────────────────────────────────────
  static const border = Color(0xFFE2E8F0);
  static const borderLight = Color(0xFFF1F5F9);
  static const grayBg = Color(0xFFF1F5F9);

  // ── Flat color sets (no gradients) ─────────────────────────────────────────
  static const List<Color> headerGrad = [darkBlue, darkBlue];
  static const List<Color> cardGrad = [darkBlue, darkBlue];
  static const List<Color> navGrad = [darkBlue, darkBlue];
  static const List<Color> heroGrad = [darkBlue, darkBlue];
}

abstract class AppLinks {
  static const privacyPolicy = 'https://lije.app/privacy';
  static const termsOfService = 'https://lije.app/terms';
  static const supportEmail = 'mailto:support@lije.app';
}
