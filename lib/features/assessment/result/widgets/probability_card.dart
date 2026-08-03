import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/probability_bar.dart';
import '../../../../data/models/enums.dart';
import 'finding_list.dart';

class ProbabilityCard extends StatefulWidget {
  const ProbabilityCard({
    super.key,
    required this.category,
    required this.probability,
    required this.color,
    required this.supporting,
    required this.against,
    required this.highlight,
  });

  final EventCategory category;
  final double probability;
  final Color color;
  final List<String> supporting;
  final List<String> against;
  final bool highlight;

  @override
  State<ProbabilityCard> createState() => _ProbabilityCardState();
}

class _ProbabilityCardState extends State<ProbabilityCard> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.highlight;
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glow: widget.highlight,
      borderColor: widget.highlight ? widget.color.withValues(alpha: 0.5) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProbabilityBar(
            label: widget.category.label,
            value: widget.probability,
            color: widget.color,
            highlight: widget.highlight,
          ),
          const SizedBox(height: 6),
          Text(
            widget.category.description,
            style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Text(
                  _expanded ? 'Hide findings' : 'Show findings',
                  style: TextStyle(color: widget.color, fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
                Icon(
                  _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  color: widget.color,
                  size: 18,
                ),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: AppSpacing.s2),
            const Divider(),
            const SizedBox(height: AppSpacing.s2),
            Text('Supporting ${widget.category.label}',
                style: const TextStyle(color: AppColors.text, fontSize: 12.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            FindingList(items: widget.supporting, supporting: true),
            if (widget.against.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Findings against',
                  style: const TextStyle(color: AppColors.text, fontSize: 12.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              FindingList(items: widget.against, supporting: false),
            ],
          ],
        ],
      ),
    );
  }
}
