import 'package:flutter/material.dart';
import '../../data/models/finding_keys.dart';
import 'finding_chip.dart';

/// Wraps a list of [FindingOption]s as toggleable [FindingChip]s bound to a
/// mutable selection [Set].
class FindingsGrid extends StatelessWidget {
  const FindingsGrid({
    super.key,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final List<FindingOption> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final option in options)
          FindingChip(
            label: option.label,
            selected: selected.contains(option.key),
            onTap: () => onToggle(option.key),
          ),
      ],
    );
  }
}
