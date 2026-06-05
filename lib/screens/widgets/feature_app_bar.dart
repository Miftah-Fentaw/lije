import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/models.dart';
import '../screens.dart' show LijeLogo;

class FeatureAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? trailing;

  const FeatureAppBar({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FeatureGlassIconBtn(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: C.darkBlue,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          const LijeLogo(size: 34),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: C.darkBlue,
                letterSpacing: -0.3,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 6),
            ...trailing!,
          ],
          const SizedBox(width: 8),
          const FeatureLangChooser(),
        ],
      ),
    );
  }
}

/// Language dropdown — same as home screen header.
class FeatureLangChooser extends StatelessWidget {
  const FeatureLangChooser({super.key});

  static const _labels = {
    AppLang.english: 'ENG',
    AppLang.amharic: 'AMH',
    AppLang.oromic: 'ORO',
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, currentLang, __) => PopupMenuButton<AppLang>(
        onSelected: (AppLang newLang) {
          langNotifier.value = newLang;
          HapticFeedback.selectionClick();
        },
        offset: const Offset(0, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: C.white,
        elevation: 6,
        shadowColor: Colors.black26,
        itemBuilder: (context) => AppLang.values
            .map((l) => PopupMenuItem<AppLang>(
                  value: l,
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _labels[l]!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: currentLang == l ? C.darkBlue : C.textLight,
                    ),
                  ),
                ))
            .toList(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _labels[currentLang]!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: C.darkBlue,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF4FC3F7),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureGlassIconBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const FeatureGlassIconBtn({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: C.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.lightBlue),
          boxShadow: [
            BoxShadow(
              color: C.darkBlue.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
