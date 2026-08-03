import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../data/models/enums.dart';
import '../../data/repositories/clinical_pearls_data.dart';
import '../../data/repositories/epilepsy_history_data.dart';
import '../../data/repositories/localization_data.dart';
import '../../data/repositories/notable_figures_data.dart';
import '../../data/repositories/seizure_library_data.dart';
import '../library/library_detail_screen.dart';
import '../library/library_screen.dart';
import '../localization/localization_screen.dart';
import '../pearls/pearls_screen.dart';

/// AppBar action that opens the global [SearchScreen] from anywhere in the
/// app — the Seizure Atlas, Localization Explorer and Clinical Pearls all
/// share one search index.
class SearchAction extends StatelessWidget {
  const SearchAction({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Search',
      icon: const Icon(Icons.search_rounded),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SearchScreen()),
      ),
    );
  }
}

enum _ResultKind { atlas, pearl, localization, history, figure }

class _SearchResult {
  const _SearchResult({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.searchText,
    required this.onTap,
  });

  final _ResultKind kind;
  final String title;
  final String subtitle;
  final String tag;
  final String searchText;
  final void Function(BuildContext context) onTap;

  IconData get icon {
    switch (kind) {
      case _ResultKind.atlas:
        return Icons.menu_book_rounded;
      case _ResultKind.pearl:
        return categoryIcon(tag);
      case _ResultKind.localization:
        return Icons.route_rounded;
      case _ResultKind.history:
        return Icons.history_rounded;
      case _ResultKind.figure:
        return Icons.person_rounded;
    }
  }

  Color get color {
    switch (kind) {
      case _ResultKind.atlas:
        return AppColors.ok;
      case _ResultKind.pearl:
        return AppColors.warn;
      case _ResultKind.localization:
        return AppColors.pnes;
      case _ResultKind.history:
      case _ResultKind.figure:
        return AppColors.brand3;
    }
  }
}

List<_SearchResult> _buildIndex() {
  final results = <_SearchResult>[];

  for (final entry in seizureLibrary) {
    results.add(_SearchResult(
      kind: _ResultKind.atlas,
      title: entry.name,
      subtitle: entry.summary,
      tag: entry.category,
      searchText: entry.searchText,
      onTap: (context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LibraryDetailScreen(entry: entry)),
      ),
    ));
  }

  for (final pearl in clinicalPearls) {
    results.add(_SearchResult(
      kind: _ResultKind.pearl,
      title: pearl.title,
      subtitle: pearl.text,
      tag: pearl.category,
      searchText: '${pearl.category} ${pearl.title} ${pearl.text}'.toLowerCase(),
      onTap: (context) => showPearlReference(context, pearl),
    ));
  }

  for (final info in localizationRegions) {
    final searchText = ('${info.region.label} ${info.typicalAura.join(' ')} '
            '${info.semiology.join(' ')} ${info.eeg} ${info.mri} '
            '${info.differentials.join(' ')}')
        .toLowerCase();
    results.add(_SearchResult(
      kind: _ResultKind.localization,
      title: info.region.label,
      subtitle: info.typicalAura.isNotEmpty ? info.typicalAura.first : 'Localization reference',
      tag: 'Localization',
      searchText: searchText,
      onTap: (context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LocalizationScreen(initialRegion: info.region)),
      ),
    ));
  }

  for (final event in epilepsyHistory) {
    results.add(_SearchResult(
      kind: _ResultKind.history,
      title: event.title,
      subtitle: event.description,
      tag: event.era,
      searchText: '${event.era} ${event.title} ${event.description}'.toLowerCase(),
      onTap: (context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LibraryScreen(initialTabIndex: 1)),
      ),
    ));
  }

  for (final figure in notableFigures) {
    results.add(_SearchResult(
      kind: _ResultKind.figure,
      title: figure.name,
      subtitle: figure.description,
      tag: figure.years,
      searchText: '${figure.name} ${figure.years} ${figure.description}'.toLowerCase(),
      onTap: (context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LibraryScreen(initialTabIndex: 2)),
      ),
    ));
  }

  return results;
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<_SearchResult> _index = _buildIndex();
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final results = q.isEmpty ? const <_SearchResult>[] : _index.where((r) => r.searchText.contains(q)).toList();

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Search')),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Search seizure types, aura, signs, localization, pearls…',
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.faint),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                  Expanded(
                    child: q.isEmpty
                        ? const _SearchHint()
                        : results.isEmpty
                            ? const _NoResults()
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                                itemCount: results.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final r = results[index];
                                  return GlassCard(
                                    hoverable: true,
                                    onTap: () => r.onTap(context),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: r.color.withValues(alpha: 0.14),
                                            borderRadius: BorderRadius.circular(AppRadii.sm),
                                            border: Border.all(color: r.color.withValues(alpha: 0.4)),
                                          ),
                                          child: Icon(r.icon, color: r.color, size: 18),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(r.title, style: const TextStyle(color: AppColors.text, fontSize: 14.5, fontWeight: FontWeight.w700)),
                                              const SizedBox(height: 3),
                                              Text(
                                                r.subtitle,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(color: AppColors.muted, fontSize: 12.5, height: 1.35),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.chevron_right_rounded, color: AppColors.faint),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Search across the Seizure Atlas, Localization Explorer, Clinical '
          'Pearls, history and notable figures — try "gelastic", '
          '"figure-of-4" or "Dostoevsky".',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.5),
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No matches.', style: TextStyle(color: AppColors.muted, fontSize: 13)),
    );
  }
}
