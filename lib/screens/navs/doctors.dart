import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/models.dart';
import '../../models/mockdata.dart';

class DoctorsTab extends StatefulWidget {
  const DoctorsTab({super.key});

  @override
  State<DoctorsTab> createState() => _DoctorsTabState();
}

class _DoctorsTabState extends State<DoctorsTab> {
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  String _query = '';
  String? _specialtyFilter;
  bool _onlineOnly = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _searchFocus.addListener(() => setState(() {}));
  }

  void _onSearchChanged() {
    setState(() => _query = _searchCtrl.text.trim().toLowerCase());
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<Doctor> _filteredDoctors() {
    return mockDoctors.where((doctor) {
      if (_onlineOnly && !doctor.isOnline) return false;
      if (_specialtyFilter != null && doctor.specialty != _specialtyFilter) {
        return false;
      }
      if (_query.isEmpty) return true;
      final haystack =
          '${doctor.name} ${doctor.specialty} ${doctor.hospital} ${doctor.bio}'
              .toLowerCase();
      return haystack.contains(_query);
    }).toList();
  }

  List<String> _specialties() {
    final list = mockDoctors.map((d) => d.specialty).toSet().toList();
    list.sort();
    return list;
  }

  void _clearSearch() {
    HapticFeedback.selectionClick();
    _searchCtrl.clear();
    _searchFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) {
        final filtered = _filteredDoctors();
        final focused = _searchFocus.hasFocus;
        final hasQuery = _query.isNotEmpty;

        return Scaffold(
          backgroundColor: C.bgPage,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(lang, filtered.length),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 52,
                    decoration: BoxDecoration(
                      color: C.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: focused ? C.darkBlue : C.lightBlue,
                        width: focused ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: C.darkBlue.withOpacity(focused ? 0.12 : 0.06),
                          blurRadius: focused ? 18 : 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Icon(
                          Icons.search_rounded,
                          color: focused ? C.darkBlue : C.textLight,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            focusNode: _searchFocus,
                            style: const TextStyle(
                              color: C.darkBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            cursorColor: C.darkBlue,
                            decoration: InputDecoration(
                              hintText: LS.get(lang, 'doctorSearchHint'),
                              hintStyle: TextStyle(
                                color: C.textLight.withOpacity(0.75),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                        if (hasQuery)
                          GestureDetector(
                            onTap: _clearSearch,
                            child: Container(
                              width: 28,
                              height: 28,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: C.lightBlue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: C.darkBlue,
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 14),
                      ],
                    ),
                  ),
                ),
                _buildFilterChips(lang),
                Expanded(
                  child: filtered.isEmpty
                      ? _buildEmptyState(lang)
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) => _DoctorCard(
                            doctor: filtered[index],
                            lang: lang,
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

  Widget _buildHeader(AppLang lang, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: C.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: C.darkBlue.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: C.darkBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LS.get(lang, 'findDoctorTitle'),
                  style: const TextStyle(
                    color: C.darkBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$count ${LS.get(lang, 'doctors')} ${LS.get(lang, 'doctorsAvailable')}',
                  style: TextStyle(
                    color: C.textLight.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(AppLang lang) {
    final specialties = _specialties();

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          _FilterChip(
            label: LS.get(lang, 'filterAll'),
            selected: _specialtyFilter == null && !_onlineOnly,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _specialtyFilter = null;
                _onlineOnly = false;
              });
            },
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: LS.get(lang, 'filterOnline'),
            selected: _onlineOnly,
            icon: Icons.circle,
            iconColor: C.success,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                _onlineOnly = !_onlineOnly;
                if (_onlineOnly) _specialtyFilter = null;
              });
            },
          ),
          ...specialties.map(
            (specialty) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _FilterChip(
                label: specialty,
                selected: _specialtyFilter == specialty,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _onlineOnly = false;
                    _specialtyFilter =
                        _specialtyFilter == specialty ? null : specialty;
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLang lang) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: C.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: C.darkBlue.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 36,
                color: C.textLight.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              LS.get(lang, 'doctorSearchEmpty'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: C.darkBlue,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LS.get(lang, 'doctorSearchEmptyHint'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: C.textLight.withOpacity(0.85),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? C.darkBlue : C.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? C.darkBlue : C.lightBlue,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: C.darkBlue.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 8, color: iconColor ?? C.success),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? C.white : C.darkBlue,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final AppLang lang;

  const _DoctorCard({required this.doctor, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: C.lightBlue.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: C.darkBlue.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    _DoctorDetailScreen(doctor: doctor, lang: lang),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _DoctorPhoto(
                      imageUrl: doctor.image,
                      width: 68,
                      height: 68,
                      borderRadius: 18,
                    ),
                    if (doctor.isOnline)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: C.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: C.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doctor.name,
                              style: const TextStyle(
                                color: C.darkBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                          ),
                          if (doctor.isOnline)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: C.success.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                LS.get(lang, 'onlineLabel'),
                                style: const TextStyle(
                                  color: C.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          color: C.textLight.withOpacity(0.95),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 14, color: C.textLight.withOpacity(0.8)),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              doctor.hospital,
                              style: TextStyle(
                                color: C.textLight.withOpacity(0.85),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: C.lightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: C.gold, size: 14),
                                const SizedBox(width: 3),
                                Text(
                                  doctor.rating.toString(),
                                  style: const TextStyle(
                                    color: C.darkBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${doctor.experience} ${LS.get(lang, 'expYears')}.',
                            style: TextStyle(
                              color: C.textLight.withOpacity(0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: C.darkBlue,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                              children: [
                                TextSpan(text: '${doctor.price.toInt()}.0 '),
                                TextSpan(
                                  text: LS.get(lang, 'etb'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: C.textLight.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: C.darkBlue,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: C.darkBlue.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              LS.get(lang, 'bookConsult'),
                              style: const TextStyle(
                                color: C.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DoctorPhoto extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final double fallbackIconSize;

  const _DoctorPhoto({
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 0,
    this.fallbackIconSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: width,
      height: height,
      color: C.frost,
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        color: C.textLight,
        size: fallbackIconSize,
      ),
    );

    if (imageUrl.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: fallback,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: C.frost,
            alignment: Alignment.center,
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: C.mid.withOpacity(0.7),
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}

class _DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;
  final AppLang lang;

  const _DoctorDetailScreen({required this.doctor, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: C.navy),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: C.navy),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: C.navy),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLargeImage(),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          color: C.navy,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        doctor.specialty,
                        style: const TextStyle(
                          color: C.mid,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(
                          Icons.location_on_rounded, doctor.hospital),
                      const SizedBox(height: 8),
                      _buildStatRow(Icons.work_rounded,
                          '${doctor.experience} Experience'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoCard(doctor.rating.toString(),
                    LS.get(lang, 'ratings'), Icons.star_rounded, C.gold),
                _buildInfoCard(doctor.reviews.toString(), 'Patients',
                    Icons.people_rounded, C.mid),
                _buildInfoCard('${doctor.price}', LS.get(lang, 'etb'),
                    Icons.payments_rounded, C.vivid),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              LS.get(lang, 'doctorBio'),
              style: const TextStyle(
                color: C.navy,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              doctor.bio,
              style: TextStyle(
                color: C.textMid.withOpacity(0.8),
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(lang),
    );
  }

  Widget _buildLargeImage() {
    return _DoctorPhoto(
      imageUrl: doctor.image,
      width: 120,
      height: 140,
      borderRadius: 24,
      fallbackIconSize: 60,
    );
  }

  Widget _buildStatRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: C.textLight),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                color: C.textLight, fontSize: 13, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: C.navy,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: C.textLight,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(AppLang lang) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: C.navy.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: C.frost,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.chat_bubble_outline_rounded, color: C.mid),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => HapticFeedback.mediumImpact(),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: C.darkBlue,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: C.darkBlue.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    LS.get(lang, 'bookConsult'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
