import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A short bullet list of findings, prefixed with a check or cross icon
/// depending on [supporting].
class FindingList extends StatelessWidget {
  const FindingList({super.key, required this.items, required this.supporting});

  final List<String> items;
  final bool supporting;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        'No specific findings recorded.',
        style: const TextStyle(color: AppColors.faint, fontSize: 12.5, fontStyle: FontStyle.italic),
      );
    }
    final color = supporting ? AppColors.ok : AppColors.danger;
    final icon = supporting ? Icons.check_circle_rounded : Icons.cancel_rounded;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 15, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(item, style: const TextStyle(color: AppColors.text2, fontSize: 12.5, height: 1.4)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
