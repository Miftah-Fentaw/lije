import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lije/features/discover/services/discover_search.dart';
import 'package:lije/models/discover_data.dart';
import 'package:lije/models/models.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  DiscoverCategory _category = DiscoverCategory.all;
  String _query = '';
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: discoverSearchNotifier.value);
    _query = discoverSearchNotifier.value;
    discoverSearchNotifier.addListener(_onExternalSearch);
  }

  void _onExternalSearch() {
    final q = discoverSearchNotifier.value;
    if (_query != q) {
      setState(() {
        _query = q;
        _searchCtrl.text = q;
      });
    }
  }

  @override
  void dispose() {
    discoverSearchNotifier.removeListener(_onExternalSearch);
    _searchCtrl.dispose();
    super.dispose();
  }

  List<DiscoverArticle> get _filtered {
    final q = _query.trim().toLowerCase();
    return DiscoverData.articles.where((a) {
      final catMatch =
          _category == DiscoverCategory.all || a.category == _category;
      if (!catMatch) return false;
      if (q.isEmpty) return true;
      final lang = langNotifier.value;
      return a.t(lang, a.title).toLowerCase().contains(q) ||
          a.t(lang, a.summary).toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (_, lang, __) {
        final articles = _filtered;
        return Scaffold(
          backgroundColor: C.bgPage,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Text(
                  LS.get(lang, 'discoverTitle'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: C.darkBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    LS.get(lang, 'discoverSubtitle'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: C.textLight,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    style: const TextStyle(color: C.darkBlue, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: LS.get(lang, 'discoverSearchHint'),
                      hintStyle: TextStyle(
                        color: C.textLight.withOpacity(0.85),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: C.textLight, size: 22),
                      filled: true,
                      fillColor: C.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: DiscoverData.filterCategories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final cat = DiscoverData.filterCategories[i];
                      final selected = _category == cat;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _category = cat);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? C.darkBlue : C.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected ? C.darkBlue : C.lightBlue,
                            ),
                          ),
                          child: Text(
                            DiscoverData.categoryLabel(lang, cat),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: selected ? C.white : C.darkBlue,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: articles.isEmpty
                      ? _EmptyState(lang: lang)
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: articles.length,
                          itemBuilder: (_, i) =>
                              _ArticleCard(article: articles[i], lang: lang),
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

class _EmptyState extends StatelessWidget {
  final AppLang lang;
  const _EmptyState({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_rounded, size: 40, color: C.darkBlue),
            const SizedBox(height: 12),
            Text(
              LS.get(lang, 'discoverEmpty'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: C.darkBlue,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final DiscoverArticle article;
  final AppLang lang;

  const _ArticleCard({required this.article, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.lightBlue),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => _ArticleDetailScreen(article: article, lang: lang),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: C.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(article.emoji, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: C.lightBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        DiscoverData.categoryLabel(lang, article.category),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: C.darkBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.t(lang, article.title),
                      style: const TextStyle(
                        color: C.darkBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.t(lang, article.summary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: C.textLight,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 13, color: C.textLight),
                        const SizedBox(width: 4),
                        Text(
                          '${article.readMinutes} ${LS.get(lang, 'minRead')}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: C.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            size: 12, color: C.textLight),
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
}

class _ArticleDetailScreen extends StatelessWidget {
  final DiscoverArticle article;
  final AppLang lang;

  const _ArticleDetailScreen({required this.article, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bgPage,
      appBar: AppBar(
        backgroundColor: C.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: C.darkBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          DiscoverData.categoryLabel(lang, article.category),
          style: const TextStyle(
            color: C.darkBlue,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: C.lightBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(article.emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article.t(lang, article.title),
              style: const TextStyle(
                color: C.darkBlue,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 14, color: C.textLight),
                const SizedBox(width: 4),
                Text(
                  '${article.readMinutes} ${LS.get(lang, 'minRead')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: C.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: C.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.lightBlue),
              ),
              child: Text(
                article.t(lang, article.body),
                style: const TextStyle(
                  color: C.darkBlue,
                  fontSize: 14,
                  height: 1.65,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
