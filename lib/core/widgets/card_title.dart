import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Bold label + optional muted note used at the top of a wizard card.
class CardTitle extends StatelessWidget {
  const CardTitle(this.title, {super.key, this.note, this.color = AppColors.text});
  final String title;
  final String? note;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15)),
          if (note != null) ...[
            const SizedBox(height: 4),
            Text(note!, style: const TextStyle(color: AppColors.muted, fontSize: 12.5, height: 1.4)),
          ],
        ],
      ),
    );
  }
}
