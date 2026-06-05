import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../screens.dart';

class DiscoverTab extends StatelessWidget {
  const DiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => PlaceholderTab(
        label: LS.get(lang, 'discover'),
        emoji: '💡',
      ),
    );
  }
}
