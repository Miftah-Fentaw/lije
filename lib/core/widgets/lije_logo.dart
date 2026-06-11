import 'package:flutter/material.dart';
import 'package:lije/core/constants/app_assets.dart';
import 'package:lije/core/theme/colors.dart';

class LijeLogo extends StatelessWidget {
  final double size;
  const LijeLogo({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        AppAssets.lijeNobg,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          AppAssets.lijePng,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _FallbackLogo(size: size),
        ),
      ),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  final double size;
  const _FallbackLogo({required this.size});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: C.lightBlue,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.favorite_rounded, color: C.coral, size: size * 0.28),
          Text('LJ',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.22,
                fontWeight: FontWeight.w900,
                height: 1.0,
              )),
        ]),
      );
}
