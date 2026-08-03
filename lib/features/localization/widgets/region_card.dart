import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/localization_region_info.dart';

class RegionCard extends StatefulWidget {
  const RegionCard({super.key, required this.info});

  final LocalizationRegionInfo info;

  @override
  State<RegionCard> createState() => _RegionCardState();
}

class _RegionCardState extends State<RegionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    return GlassCard(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  info.region.label,
                  style: const TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              Icon(
                _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                color: AppColors.brand3,
              ),
            ],
          ),
          if (_expanded) ...[
            const SizedBox(height: AppSpacing.s3),
            _block('Typical aura', info.typicalAura),
            _block('Semiology', info.semiology),
            const SizedBox(height: 4),
            _text('EEG', info.eeg),
            _text('MRI findings', info.mri),
            _block('Differentials', info.differentials),
          ],
        ],
      ),
    );
  }

  Widget _block(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
