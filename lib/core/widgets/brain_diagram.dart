import 'package:flutter/material.dart';
import '../../data/models/enums.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// A stylized, interactive lateral-view brain diagram used by both the
/// Localization Explorer and the Result dashboard. Each lobe is a
/// tappable/hoverable region; [LocalizationRegion.insular] is drawn as a
/// small deep marker and [LocalizationRegion.generalized] highlights the
/// whole silhouette (selected via the legend below, not a screen position).
///
/// This is an illustrative schematic, not an anatomically precise atlas —
/// intended to help a physician recognize "roughly where" at a glance.
class BrainDiagram extends StatefulWidget {
  const BrainDiagram({
    super.key,
    this.selected,
    this.onSelect,
    this.onHover,
    this.confidences,
    this.interactive = true,
  });

  /// The currently highlighted region (persistent selection).
  final LocalizationRegion? selected;

  /// Called when the user taps a lobe or a legend chip. Null when read-only.
  final ValueChanged<LocalizationRegion>? onSelect;

  /// Called on hover enter/exit (desktop/web pointer only); null on exit.
  final ValueChanged<LocalizationRegion?>? onHover;

  /// Optional 0..1 confidence per region, used to modulate highlight
  /// intensity (e.g. on the Result dashboard).
  final Map<LocalizationRegion, double>? confidences;

  /// When false, lobes are display-only (no tap/hover feedback) — used for
  /// a compact, non-editable "predicted lobe" summary.
  final bool interactive;

  @override
  State<BrainDiagram> createState() => _BrainDiagramState();
}

class _BrainDiagramState extends State<BrainDiagram> {
  LocalizationRegion? _hovered;

  static const _lobeFractions = <LocalizationRegion, Rect>{
    LocalizationRegion.frontal: Rect.fromLTRB(0.0, 0.0, 0.42, 0.66),
    LocalizationRegion.parietal: Rect.fromLTRB(0.42, 0.0, 0.74, 0.40),
    LocalizationRegion.occipital: Rect.fromLTRB(0.74, 0.10, 1.0, 0.72),
    LocalizationRegion.temporal: Rect.fromLTRB(0.14, 0.58, 0.66, 1.0),
  };

  Color _colorFor(LocalizationRegion region) {
    switch (region) {
      case LocalizationRegion.frontal:
        return AppColors.brand3;
      case LocalizationRegion.parietal:
        return AppColors.pnes;
      case LocalizationRegion.occipital:
        return AppColors.ok;
      case LocalizationRegion.temporal:
        return AppColors.warn;
      case LocalizationRegion.insular:
        return AppColors.danger;
      case LocalizationRegion.generalized:
        return AppColors.brand;
    }
  }

  void _setHover(LocalizationRegion? region) {
    if (!widget.interactive) return;
    setState(() => _hovered = region);
    widget.onHover?.call(region);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 1.45,
          child: ClipPath(
            clipper: _BrainOutlineClipper(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.ink700, AppColors.ink900],
                ),
              ),
              child: CustomPaint(
                painter: _BrainSurfacePainter(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(constraints.maxWidth, constraints.maxHeight);
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        if (widget.selected == LocalizationRegion.generalized)
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: _colorFor(LocalizationRegion.generalized).withValues(alpha: 0.22)),
                            ),
                          ),
                        for (final entry in _lobeFractions.entries) _lobeRegion(entry.key, entry.value, size),
                        _insularMarker(size),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (final region in LocalizationRegion.values) _legendChip(region),
          ],
        ),
      ],
    );
  }

  Widget _lobeRegion(LocalizationRegion region, Rect fraction, Size size) {
    final rect = Rect.fromLTWH(
      fraction.left * size.width,
      fraction.top * size.height,
      fraction.width * size.width,
      fraction.height * size.height,
    );
    final active = widget.selected == region;
    final hovered = _hovered == region;
    final confidence = widget.confidences?[region];
    final baseAlpha = active ? 0.42 : (hovered ? 0.26 : 0.08);
    final alpha = confidence != null ? (baseAlpha * (0.5 + confidence * 0.5)).clamp(0.06, 0.55) : baseAlpha;

    Widget region0 = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: _colorFor(region).withValues(alpha: alpha),
        border: Border.all(
          color: _colorFor(region).withValues(alpha: active || hovered ? 0.7 : 0.0),
          width: 1.5,
        ),
      ),
    );

    if (widget.interactive) {
      region0 = MouseRegion(
        onEnter: (_) => _setHover(region),
        onExit: (_) => _setHover(null),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => widget.onSelect?.call(region),
          child: region0,
        ),
      );
    }

    return Positioned.fromRect(rect: rect, child: region0);
  }

  Widget _insularMarker(Size size) {
    const cx = 0.50;
    const cy = 0.55;
    const r = 0.05;
    final active = widget.selected == LocalizationRegion.insular;
    final hovered = _hovered == LocalizationRegion.insular;
    final d = size.shortestSide * r * 2;

    Widget marker = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: d,
      height: d,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _colorFor(LocalizationRegion.insular).withValues(alpha: active ? 0.85 : (hovered ? 0.6 : 0.35)),
        border: Border.all(color: AppColors.text.withValues(alpha: 0.6), width: 1.5),
      ),
    );

    if (widget.interactive) {
      marker = MouseRegion(
        onEnter: (_) => _setHover(LocalizationRegion.insular),
        onExit: (_) => _setHover(null),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => widget.onSelect?.call(LocalizationRegion.insular),
          child: marker,
        ),
      );
    }

    return Positioned(
      left: size.width * cx - d / 2,
      top: size.height * cy - d / 2,
      child: marker,
    );
  }

  Widget _legendChip(LocalizationRegion region) {
    final active = widget.selected == region;
    final color = _colorFor(region);
    final chip = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.16) : AppColors.ink800,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        border: Border.all(color: active ? color.withValues(alpha: 0.7) : AppColors.line2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            region.label.replaceAll(' lobe', '').replaceAll(' onset', '').replaceAll(' / opercular', ''),
            style: TextStyle(
              color: active ? AppColors.text : AppColors.text2,
              fontSize: 11.5,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    if (!widget.interactive || widget.onSelect == null) return chip;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.pill),
      onTap: () => widget.onSelect?.call(region),
      child: chip,
    );
  }
}

/// Hand-drawn stylized lateral brain silhouette: frontal bulge at front-top,
/// parietal along the top-back, occipital tapering to a point at the back,
/// and a temporal lobe hanging below a concave "sylvian fissure" notch.
class _BrainOutlineClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Offset p(double fx, double fy) => Offset(fx * size.width, fy * size.height);

    final path = Path()..moveTo(p(0.10, 0.42).dx, p(0.10, 0.42).dy);
    path.cubicTo(
      p(0.06, 0.30).dx, p(0.06, 0.30).dy,
      p(0.10, 0.20).dx, p(0.10, 0.20).dy,
      p(0.14, 0.18).dx, p(0.14, 0.18).dy,
    );
    path.cubicTo(
      p(0.20, 0.08).dx, p(0.20, 0.08).dy,
      p(0.30, 0.04).dx, p(0.30, 0.04).dy,
      p(0.42, 0.05).dx, p(0.42, 0.05).dy,
    );
    path.cubicTo(
      p(0.52, 0.02).dx, p(0.52, 0.02).dy,
      p(0.62, 0.03).dx, p(0.62, 0.03).dy,
      p(0.70, 0.08).dx, p(0.70, 0.08).dy,
    );
    path.cubicTo(
      p(0.80, 0.10).dx, p(0.80, 0.10).dy,
      p(0.90, 0.14).dx, p(0.90, 0.14).dy,
      p(0.92, 0.24).dx, p(0.92, 0.24).dy,
    );
    path.cubicTo(
      p(0.98, 0.32).dx, p(0.98, 0.32).dy,
      p(0.99, 0.40).dx, p(0.99, 0.40).dy,
      p(0.97, 0.48).dx, p(0.97, 0.48).dy,
    );
    path.cubicTo(
      p(0.97, 0.58).dx, p(0.97, 0.58).dy,
      p(0.94, 0.64).dx, p(0.94, 0.64).dy,
      p(0.88, 0.68).dx, p(0.88, 0.68).dy,
    );
    path.cubicTo(
      p(0.80, 0.74).dx, p(0.80, 0.74).dy,
      p(0.74, 0.76).dx, p(0.74, 0.76).dy,
      p(0.68, 0.74).dx, p(0.68, 0.74).dy,
    );
    path.cubicTo(
      p(0.63, 0.70).dx, p(0.63, 0.70).dy,
      p(0.62, 0.66).dx, p(0.62, 0.66).dy,
      p(0.58, 0.62).dx, p(0.58, 0.62).dy,
    );
    path.cubicTo(
      p(0.56, 0.68).dx, p(0.56, 0.68).dy,
      p(0.62, 0.74).dx, p(0.62, 0.74).dy,
      p(0.62, 0.82).dx, p(0.62, 0.82).dy,
    );
    path.cubicTo(
      p(0.62, 0.90).dx, p(0.62, 0.90).dy,
      p(0.52, 0.93).dx, p(0.52, 0.93).dy,
      p(0.40, 0.92).dx, p(0.40, 0.92).dy,
    );
    path.cubicTo(
      p(0.30, 0.92).dx, p(0.30, 0.92).dy,
      p(0.22, 0.90).dx, p(0.22, 0.90).dy,
      p(0.18, 0.84).dx, p(0.18, 0.84).dy,
    );
    path.cubicTo(
      p(0.12, 0.78).dx, p(0.12, 0.78).dy,
      p(0.05, 0.72).dx, p(0.05, 0.72).dy,
      p(0.06, 0.62).dx, p(0.06, 0.62).dy,
    );
    path.cubicTo(
      p(0.04, 0.54).dx, p(0.04, 0.54).dy,
      p(0.06, 0.46).dx, p(0.06, 0.46).dy,
      p(0.10, 0.42).dx, p(0.10, 0.42).dy,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Draws the outline stroke plus a couple of faint gyral folds on top of the
/// clipped silhouette for texture.
class _BrainSurfacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final clipper = _BrainOutlineClipper();
    final outline = clipper.getClip(size);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.line2;
    canvas.drawPath(outline, strokePaint);

    final foldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = AppColors.line2.withValues(alpha: 0.6);

    for (final t in [0.30, 0.48, 0.66]) {
      canvas.drawLine(
        Offset(size.width * 0.16, size.height * t),
        Offset(size.width * 0.80, size.height * (t - 0.05)),
        foldPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
