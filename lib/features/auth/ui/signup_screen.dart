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
import 'package:lije/features/auth/services/user_id_generator.dart';
import 'package:lije/features/auth/ui/login_screen.dart';
import 'package:lije/features/auth/ui/widgets/carrier_phone_field.dart';
import 'package:lije/features/auth/ui/widgets/phone_confirm_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  Carrier _carrier = Carrier.ethiotelecom;
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLang lang) async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final phone = '${_carrier.prefix}${_phoneCtrl.text.trim()}';

    final confirmed = await showPhoneConfirmDialog(
      context,
      lang: lang,
      phone: phone,
      carrier: _carrier,
    );
    if (!confirmed || !mounted) return;

    setState(() => _submitting = true);

    try {
      final user = AuthUser(
        userId: generateUserId(phone, name),
        name: name,
        phone: phone,
        carrier: _carrier,
      );

      final saved = await AuthStorage.signUp(user);
      if (!mounted) return;

      await appState.bindUser(saved.supabaseId);
      await NotificationService.rescheduleAll(appState);
      if (!mounted) return;

      await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      final message = e.message == 'phone already registered'
          ? LS.get(lang, 'authPhoneTaken')
          : LS.get(lang, 'authNetworkError');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: C.error,
      ));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(LS.get(lang, 'authNetworkError')),
        backgroundColor: C.error,
      ));
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
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(child: LijeLogo(size: 72)),
                        const SizedBox(height: 24),
                        Text(
                          s('authSignupTitle'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: C.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          s('authSignupSubtitle'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: C.textLight,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          s('authNameLabel'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: C.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameCtrl,
                          enabled: !_submitting,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          validator: (v) => AuthValidators.name(lang, v),
                          decoration: InputDecoration(
                            hintText: s('authNameHint'),
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: C.textLight,
                            ),
                            filled: true,
                            fillColor: C.grayBg,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: C.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: C.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: C.primary,
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: C.error),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: C.error,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
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
                                borderRadius: BorderRadius.circular(14),
                              ),
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
                                : Text(
                                    s('authSignupButton'),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              s('authHaveAccount'),
                              style: const TextStyle(
                                fontSize: 13,
                                color: C.textLight,
                              ),
                            ),
                            GestureDetector(
                              onTap: _submitting
                                  ? null
                                  : () => Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      ),
                              child: Text(
                                s('authLoginLink'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: C.darkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
