import 'package:flutter/material.dart';
import 'package:lije/core/theme/colors.dart';
import 'package:lije/core/widgets/lije_logo.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN SHELL  (shared by sub-screens)
// ─────────────────────────────────────────────────────────────────────────────
class ScreenShell extends StatelessWidget {
  final String title;
  final Widget body;
  const ScreenShell({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: C.bgPage,
        body: Column(children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: C.headerGrad,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              boxShadow: [
                BoxShadow(
                    color: Color(0x330096C7),
                    blurRadius: 12,
                    offset: Offset(0, 4))
              ],
            ),
            child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 14),
                  child: Row(children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20)),
                    const LijeLogo(size: 36),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)),
                  ]),
                )),
          ),
          Expanded(child: body),
        ]),
      );
}
