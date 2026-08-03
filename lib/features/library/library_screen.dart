import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/seizure_library_entry.dart';
import '../../data/repositories/seizure_library_data.dart';
import '../search/search_screen.dart';
import 'library_detail_screen.dart';
import 'widgets/history_tab.dart';
import 'widgets/notable_figures_tab.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, this.initialTabIndex = 0});

  /// 0 = Atlas, 1 = History, 2 = Notable Figures.
  final int initialTabIndex;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: widget.initialTabIndex,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Library'),
          actions: [SearchAction()],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.brand3,
            labelColor: AppColors.text,
            unselectedLabelColor: AppColors.muted,
            tabs: const [
              Tab(text: 'Atlas'),
              Tab(text: 'History'),
              Tab(text: 'Notable Figures'),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _AtlasTab(),
                  HistoryTab(),
                  NotableFiguresTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AtlasTab extends StatefulWidget {
  const _AtlasTab();

  @override
  State<_AtlasTab> createState() => _AtlasTabState();
}

class _AtlasTabState extends State<_AtlasTab> {
  String _query = '';
  bool _rareOnly = false;

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    var results = _rareOnly ? seizureLibrary.where((e) => e.isRare).toList() : seizureLibrary;
    if (q.isNotEmpty) {
      results = results.where((e) => e.searchText.contains(q)).toList();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                kicker: 'Module 3',
                title: 'Seizure types & syndromes',
              ),
              const SizedBox(height: AppSpacing.s4),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search by name, category or feature…',
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.faint),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: AppSpacing.s3),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All types'),
                    selected: !_rareOnly,
                    onSelected: (_) => setState(() => _rareOnly = false),
                  ),
                  ChoiceChip(
                    label: const Text('Rare types only'),
                    selected: _rareOnly,
                    onSelected: (_) => setState(() => _rareOnly = true),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            itemCount: results.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final entry = results[index];
              return _EntryCard(entry: entry);
            },
          ),
        ),
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final SeizureLibraryEntry entry;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      hoverable: true,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LibraryDetailScreen(entry: entry)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: const TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.brand.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                  child: Text(entry.category, style: const TextStyle(color: AppColors.brand, fontSize: 10.5, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 6),
                Text(
                  entry.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12.5, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          const Icon(Icons.chevron_right_rounded, color: AppColors.faint),
        ],
      ),
    );
  }
}
