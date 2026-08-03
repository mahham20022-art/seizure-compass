import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/brain_diagram.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/enums.dart';
import '../../data/models/localization_region_info.dart';
import '../../data/repositories/localization_data.dart';
import '../search/search_screen.dart';

class LocalizationScreen extends StatefulWidget {
  const LocalizationScreen({super.key, this.initialRegion});

  /// Pre-selects a lobe, e.g. when arriving from the Result dashboard or
  /// global search.
  final LocalizationRegion? initialRegion;

  @override
  State<LocalizationScreen> createState() => _LocalizationScreenState();
}

class _LocalizationScreenState extends State<LocalizationScreen> {
  late LocalizationRegion _selected = widget.initialRegion ?? LocalizationRegion.temporal;
  LocalizationRegion? _hovered;

  LocalizationRegionInfo get _info =>
      localizationRegions.firstWhere((r) => r.region == (_hovered ?? _selected));

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Localization explorer'),
          actions: [SearchAction()],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  const SectionHeader(
                    kicker: 'Module 2',
                    title: 'Seizure localization by lobe',
                    subtitle: 'Tap a lobe (or a legend chip) to review its typical aura, semiology, EEG and MRI findings.',
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  GlassCard(
                    child: BrainDiagram(
                      selected: _selected,
                      onSelect: (region) => setState(() => _selected = region),
                      onHover: (region) => setState(() => _hovered = region),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  _RegionDetailPanel(info: _info),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegionDetailPanel extends StatelessWidget {
  const _RegionDetailPanel({required this.info});

  final LocalizationRegionInfo info;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      key: ValueKey(info.region),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info.region.label,
            style: const TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.s4),
          _block('Typical aura', info.typicalAura),
          _block('Semiology', info.semiology),
          _text('EEG', info.eeg),
          _text('MRI findings', info.mri),
          _block('Differentials', info.differentials, last: true),
        ],
      ),
    );
  }

  Widget _block(String title, List<String> items, {bool last = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.brand, fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 6),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  ', style: TextStyle(color: AppColors.faint)),
                  Expanded(child: Text(item, style: const TextStyle(color: AppColors.text2, fontSize: 13, height: 1.4))),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _text(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppColors.brand, fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: AppColors.text2, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}
