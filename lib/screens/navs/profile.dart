import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/models.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Scaffold(
        backgroundColor: C.bgPage,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(lang),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSection(
                      context,
                      title: LS.get(lang, 'settings'),
                      items: [
                        _ProfileItem(
                          icon: Icons.settings_outlined,
                          title: LS.get(lang, 'settings'),
                          color: Colors.blueGrey,
                        ),
                        _ProfileItem(
                          icon: Icons.lock_outline_rounded,
                          title: 'Privacy & Policy',
                          color: Colors.teal,
                        ),
                        _ProfileItem(
                          icon: Icons.info_outline_rounded,
                          title: 'About Us',
                          color: C.navy,
                        ),
                        _ProfileItem(
                          icon: Icons.description_outlined,
                          title: 'Terms of Service',
                          color: C.mid,
                        ),
                        _ProfileItem(
                          icon: Icons.help_outline_rounded,
                          title: LS.get(lang, 'helpCenter'),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Lije v1.0.0',
                      style: TextStyle(
                        color: C.textLight.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(AppLang lang) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Text(
        LS.get(lang, 'profile'),
        style: const TextStyle(
          color: C.navy,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }


  Widget _buildSection(BuildContext context,
      {required String title, required List<_ProfileItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: C.mid,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: C.navy.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: 54,
              endIndent: 16,
              color: C.pale.withOpacity(0.5),
            ),
            itemBuilder: (_, i) => _buildListTile(context, items[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, _ProfileItem item) {
    return InkWell(
      onTap: () => HapticFeedback.lightImpact(),
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: C.navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (item.showArrow)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: C.textLight.withOpacity(0.4),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem {
  final IconData icon;
  final String title;
  final Color color;
  final bool showArrow;

  _ProfileItem({
    required this.icon,
    required this.title,
    required this.color,
    this.showArrow = true,
  });
}
