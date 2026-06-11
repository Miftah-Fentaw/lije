import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lije/core/theme/colors.dart';
import 'package:lije/features/auth/models/auth_user.dart';

/// A network (carrier) selector showing "ETH +251" / "SFR +251", paired with
/// a phone number input that is prefilled with the network's leading digit
/// (9 or 7) — the user only types the remaining 8 digits.
class CarrierPhoneField extends StatelessWidget {
  final Carrier carrier;
  final ValueChanged<Carrier?> onCarrierChanged;
  final TextEditingController controller;
  final String? Function(String?) phoneValidator;
  final String label;

  const CarrierPhoneField({
    super.key,
    required this.carrier,
    required this.onCarrierChanged,
    required this.controller,
    required this.phoneValidator,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: C.textDark)),
      const SizedBox(height: 6),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: C.grayBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: C.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Carrier>(
              value: carrier,
              onChanged: onCarrierChanged,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: C.textLight),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: C.textDark),
              items: Carrier.values
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text('${c.shortName} ${c.dialCode}'),
                      ))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            validator: phoneValidator,
            decoration: InputDecoration(
              prefixText: carrier.prefix,
              prefixStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: C.textDark),
              hintText: 'XXXXXXXX',
              hintStyle: const TextStyle(fontSize: 13, color: C.textLight),
              filled: true,
              fillColor: C.grayBg,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: C.border)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: C.border)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: C.primary, width: 1.5)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: C.error)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: C.error, width: 1.5)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            ),
          ),
        ),
      ]),
    ]);
  }
}
