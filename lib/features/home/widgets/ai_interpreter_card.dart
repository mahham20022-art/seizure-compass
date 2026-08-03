import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/shimmer_box.dart';

/// Placeholder UI for a future AI-assisted event interpreter: a physician
/// pastes a witness description here. No analysis happens yet — a future
/// release will parse it against seizure-semiology patterns. Tapping
/// "Analyze" only demonstrates the interface (a brief shimmer, then a
/// "coming soon" notice) — it must never claim to produce a real result.
class AiInterpreterCard extends StatefulWidget {
  const AiInterpreterCard({super.key});

  @override
  State<AiInterpreterCard> createState() => _AiInterpreterCardState();
}

class _AiInterpreterCardState extends State<AiInterpreterCard> {
  final _controller = TextEditingController();
  bool _analyzing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    if (_controller.text.trim().isEmpty || _analyzing) return;
    setState(() => _analyzing = true);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() => _analyzing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI Event Interpreter is coming in a future release.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderColor: AppColors.pnes.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.pnes.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  border: Border.all(color: AppColors.pnes.withValues(alpha: 0.4)),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: AppColors.pnes, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'AI Event Interpreter',
                  style: TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.pnes.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: const Text('Coming soon', style: TextStyle(color: AppColors.pnes, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Describe the event as witnessed, in free text. A future release '
            'will analyze it against seizure-semiology patterns.',
            style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            minLines: 3,
            maxLines: 6,
            style: const TextStyle(color: AppColors.text, fontSize: 13.5, height: 1.4),
            decoration: const InputDecoration(
              hintText: '"The patient suddenly stopped talking, stared blankly, '
                  'developed lip smacking, then became confused for two minutes."',
              hintStyle: TextStyle(color: AppColors.faint, fontSize: 12.5, height: 1.4),
            ),
          ),
          const SizedBox(height: 12),
          if (_analyzing) ...[
            const ShimmerBox(width: double.infinity, height: 12),
            const SizedBox(height: 8),
            const ShimmerBox(width: 220, height: 12),
            const SizedBox(height: 8),
            const ShimmerBox(width: 150, height: 12),
          ] else
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: _analyze,
                icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                label: const Text('Analyze'),
              ),
            ),
        ],
      ),
    );
  }
}
