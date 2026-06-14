import 'package:flutter/material.dart';
import 'package:lije/app/shell/main_shell.dart';
import 'package:lije/core/l10n/strings.dart';
import 'package:lije/core/theme/colors.dart';
import 'package:lije/core/widgets/lije_logo.dart';
import 'package:lije/core/services/notification_service.dart';
import 'package:lije/features/home/models/app_state.dart';
import 'package:lije/features/auth/models/auth_user.dart';
import 'package:lije/features/auth/services/auth_storage.dart';
import 'package:lije/features/auth/services/auth_validators.dart';
import 'package:lije/features/auth/ui/signup_screen.dart';
import 'package:lije/features/auth/ui/widgets/carrier_phone_field.dart';
import 'package:lije/features/auth/ui/widgets/phone_confirm_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  Carrier _carrier = Carrier.ethiotelecom;
  String? _error;
  bool _submitting = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLang lang) async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;

    final phone = '${_carrier.prefix}${_phoneCtrl.text.trim()}';

    final confirmed = await showPhoneConfirmDialog(
      context,
      lang: lang,
      phone: phone,
      carrier: _carrier,
    );
    if (!confirmed || !mounted) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final user = await AuthStorage.logIn(phone: phone, carrier: _carrier);
      if (!mounted) return;

      await appState.bindUser(user.supabaseId);
      await NotificationService.rescheduleAll(appState);
      if (!mounted) return;

      await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      final message = e.message == 'no account found'
          ? LS.get(lang, 'authNoMatch')
          : LS.get(lang, 'authNetworkError');
      setState(() => _error = message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = LS.get(lang, 'authNetworkError'));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (context, lang, _) {
        String s(String key) => LS.get(lang, key);
        return Scaffold(
          backgroundColor: C.bgPage,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: LijeLogo(size: 72)),
                    const SizedBox(height: 24),
                    Text(s('authLoginTitle'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: C.darkBlue)),
                    const SizedBox(height: 6),
                    Text(s('authLoginSubtitle'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: C.textLight)),
                    const SizedBox(height: 32),
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: C.errorLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: C.error.withValues(alpha: 0.2)),
                        ),
                        child: Row(children: [
                          const Text('⚠️', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(_error!,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: C.error))),
                        ]),
                      ),
                      const SizedBox(height: 18),
                    ],
                    CarrierPhoneField(
                      label: s('authPhoneLabel'),
                      carrier: _carrier,
                      controller: _phoneCtrl,
                      onCarrierChanged: (c) {
                        if (c != null) setState(() => _carrier = c);
                      },
                      phoneValidator: (v) => AuthValidators.phone(lang, v),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : () => _submit(lang),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: C.darkBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(s('authLoginButton'),
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s('authNoAccount'),
                            style: const TextStyle(
                                fontSize: 13, color: C.textLight)),
                        GestureDetector(
                          onTap: _submitting
                              ? null
                              : () => Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => const SignupScreen()),
                                  ),
                          child: Text(s('authSignupLink'),
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: C.darkBlue)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
