import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/models.dart';
import '../../models/mockdata.dart';

class DoctorsTab extends StatelessWidget {
  const DoctorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) => Scaffold(
        backgroundColor: C.bgPage,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                LS.get(lang, 'findDoctorTitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: C.navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: C.frost,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: C.textLight, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        LS.get(lang, 'searchHint'),
                        style: TextStyle(
                          color: C.textLight.withOpacity(0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: mockDoctors.length,
                  itemBuilder: (context, index) =>
                      _buildDoctorCard(context, mockDoctors[index], lang),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor, AppLang lang) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: C.deep.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDoctorImage(doctor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            style: const TextStyle(
                              color: C.navy,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ),
                        if (doctor.isOnline)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 6, top: 4),
                            decoration: const BoxDecoration(
                              color: C.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(
                        color: C.textMid,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: C.gold, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          doctor.rating.toString(),
                          style: const TextStyle(
                            color: C.navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${doctor.experience} ${LS.get(lang, 'expYears')}.',
                          style: const TextStyle(
                            color: C.textLight,
                            fontSize: 13,
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
                              color: C.navy,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                            children: [
                              TextSpan(text: '${doctor.price.toInt()}.0 '),
                              const TextSpan(
                                text: 'etb',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: C.frost,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            LS.get(lang, 'bookConsult'),
                            style: const TextStyle(
                              color: C.mid,
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
    );
  }

  Widget _buildDoctorImage(Doctor doctor) {
    return _DoctorPhoto(
      imageUrl: doctor.image,
      width: 64,
      height: 64,
      borderRadius: 32,
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
