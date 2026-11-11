import 'package:flutter/material.dart';
import '../../data/models/enums.dart';
import '../fx/motion.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// An interactive lateral view of the left hemisphere, used by the
/// Localization Explorer and the Result dashboard. The lobes follow the
/// central and lateral sulci; each is tappable and hoverable.
/// [LocalizationRegion.insular] is a marker deep to the lateral sulcus and
/// [LocalizationRegion.generalized] lights the whole hemisphere (chosen from
/// the legend). The selected region shows activity spreading from its focus.
///
/// An illustration with simplified gyri, to show "roughly where" at a
/// glance. It is not an atlas plate.
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

class _BrainDiagramState extends State<BrainDiagram> with TickerProviderStateMixin {
  LocalizationRegion? _hovered;

  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  /// Drives the rings that spread from the selected region's focus.
  late final AnimationController _spreadController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      _pulseController.value = 0.6;
      _spreadController.value = 0.5;
    } else if (!_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
      _spreadController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spreadController.dispose();
    super.dispose();
  }

  static Color _colorFor(LocalizationRegion region) {
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
    if (!widget.interactive || _hovered == region) return;
    setState(() => _hovered = region);
    widget.onHover?.call(region);
  }

  @override
  Widget build(BuildContext context) {
    final Widget art = AspectRatio(
      aspectRatio: _BrainArt.box.width / _BrainArt.box.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          final Widget paint = RepaintBoundary(
            child: CustomPaint(
              size: size,
              painter: _BrainPainter(
                selected: widget.selected,
                hovered: _hovered,
                confidences: widget.confidences,
                pulse: _pulseController,
                spread: _spreadController,
                colorFor: _colorFor,
              ),
            ),
          );
          if (!widget.interactive) return paint;
          return MouseRegion(
            cursor: _hovered != null ? SystemMouseCursors.click : MouseCursor.defer,
            onHover: (event) => _setHover(_BrainArt.regionAt(event.localPosition, size)),
            onExit: (_) => _setHover(null),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (details) {
                final region = _BrainArt.regionAt(details.localPosition, size);
                if (region != null) widget.onSelect?.call(region);
              },
              child: paint,
            ),
          );
        },
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: 'Left hemisphere, lateral view${widget.selected == null ? '' : ': ${widget.selected!.label} highlighted'}',
          child: art,
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

/// Geometry of the illustration, in a 400 x 300 drawing space. The same
/// outline and sulcal landmarks as The Tract's NeuroMaze atlas.
class _BrainArt {
  _BrainArt._();

  /// The part of the drawing space that is shown.
  static const box = Rect.fromLTWH(14, 12, 372, 288);

  static final Path outline = _svg(
    'M28 138 C30 90 70 48 130 34 C175 24 230 22 275 32 C320 44 356 76 368 118 C374 140 372 158 364 170 '
    'C352 188 330 200 300 206 C262 214 228 226 196 230 C166 234 140 230 126 218 C114 208 110 192 118 182 '
    'L128 174 C100 178 70 178 50 168 C36 160 28 150 28 138 Z',
  );

  static final Path cerebellum = _svg(
    'M262 214 C280 198 330 192 356 204 C372 214 370 240 352 254 C330 268 288 268 266 254 C254 244 254 226 262 214 Z',
  );

  static final Path brainstem = _svg(
    'M218 222 C226 214 246 214 254 222 C260 236 258 252 248 260 C246 270 246 284 246 296 L230 296 '
    'C230 284 228 270 226 262 C214 254 210 234 218 222 Z',
  );

  static final Path centralSulcus = _svg('M214 26 C208 60 196 80 200 100 C204 118 186 135 184 158');
  static final Path lateralSulcus = _svg('M128 174 C170 166 215 152 255 140 L268 124');

  /// Each lobe as one or more shapes; they overrun the outline and are clipped to it.
  static final Map<LocalizationRegion, List<Path>> lobes = {
    LocalizationRegion.frontal: [
      // frontal lobe, including the precentral gyrus (the central sulcus is its posterior border)
      _svg('M0 -5 L216 -5 L214 26 C208 60 196 80 200 100 C204 118 186 135 184 158 L128 174 L0 182 Z'),
    ],
    LocalizationRegion.parietal: [
      _svg('M216 -5 L334 -5 L330 58 L318 150 L262 134 L255 140 L184 158 C186 135 204 118 200 100 C196 80 208 60 214 26 Z'),
    ],
    LocalizationRegion.occipital: [
      _svg('M334 -5 L410 -5 L410 310 L296 310 L300 206 L318 150 L330 58 Z'),
    ],
    LocalizationRegion.temporal: [
      _svg('M128 174 L255 140 L262 134 L318 150 L300 206 L296 310 L90 310 L100 190 Z'),
    ],
  };

  /// Where activity is drawn as starting, for each region.
  static const Map<LocalizationRegion, Offset> focus = {
    LocalizationRegion.frontal: Offset(104, 104),
    LocalizationRegion.parietal: Offset(272, 84),
    LocalizationRegion.occipital: Offset(346, 140),
    LocalizationRegion.temporal: Offset(206, 198),
    LocalizationRegion.insular: Offset(204, 153),
    LocalizationRegion.generalized: Offset(200, 128),
  };

  static const insulaRadius = 10.0;

  /// Gyri as centre lines with a width; drawn as rounded bands so the gaps read as sulci.
  static final List<(Path, double)> gyri = [
    for (final g in const <(String, double)>[
      ('M30 136 C30 118 36 104 46 92', 20),
      ('M84 50 C70 58 58 66 50 78', 18),
      ('M262 66 C286 72 304 82 318 94', 20),
      ('M300 104 C292 110 286 116 282 124', 14),
      ('M362 118 C368 134 370 150 364 168', 16),
      ('M110 232 C122 238 134 238 146 232', 12),
      ('M240 92 C246 104 246 116 240 124', 12),
      ('M36 158 C66 170 100 172 126 168', 18),
      ('M44 140 C70 130 100 126 132 128 C146 134 152 146 154 160', 22),
      ('M118 136 C126 146 130 156 132 166', 12),
      ('M36 108 C70 90 120 82 170 86', 28),
      ('M56 66 C96 50 146 40 190 36', 28),
      ('M160 60 C166 74 170 84 172 98', 15),
      ('M201 30 C195 60 184 80 188 100 C192 118 176 136 172 160', 23),
      ('M228 30 C222 64 210 86 214 104 C218 122 200 136 198 152', 23),
      ('M252 38 C280 42 312 56 330 72 C334 86 322 98 302 98 C284 98 268 92 256 84', 26),
      ('M244 126 C254 112 272 110 282 122 C290 134 282 148 268 148', 22),
      ('M296 122 C312 114 328 124 326 140 C324 154 310 160 298 152', 22),
      ('M342 90 C358 110 366 132 362 152', 22),
      ('M326 158 C344 166 356 170 364 164', 18),
      ('M312 184 C330 186 346 182 358 174', 18),
      ('M130 186 C180 172 230 158 274 150', 22),
      ('M124 206 C180 196 240 184 302 176', 26),
      ('M136 228 C190 224 250 212 304 198', 22),
    ])
      (_svg(g.$1), g.$2),
  ];

  /// Which region a point of the widget falls on, or null.
  static LocalizationRegion? regionAt(Offset local, Size size) {
    final k = size.width / box.width;
    final p = Offset(local.dx / k + box.left, local.dy / k + box.top);
    if ((p - focus[LocalizationRegion.insular]!).distance <= insulaRadius * 1.9) return LocalizationRegion.insular;
    if (!outline.contains(p)) return null;
    for (final entry in lobes.entries) {
      for (final path in entry.value) {
        if (path.contains(p)) return entry.key;
      }
    }
    return null;
  }

  /// Builds a path from absolute SVG commands (M, L, C, Q, Z).
  static Path _svg(String d) {
    final tokens = RegExp(r'[MLCQZ]|-?\d*\.?\d+').allMatches(d).map((m) => m.group(0)!).toList();
    final path = Path();
    var i = 0;
    var cmd = 'M';
    double next() => double.parse(tokens[i++]);
    while (i < tokens.length) {
      if (RegExp(r'[MLCQZ]').hasMatch(tokens[i])) cmd = tokens[i++];
      switch (cmd) {
        case 'M':
          path.moveTo(next(), next());
          cmd = 'L';
        case 'L':
          path.lineTo(next(), next());
        case 'Q':
          path.quadraticBezierTo(next(), next(), next(), next());
        case 'C':
          path.cubicTo(next(), next(), next(), next(), next(), next());
        case 'Z':
          path.close();
      }
    }
    return path;
  }
}

/// Paints the hemisphere: cerebellum and brainstem behind, gyral relief,
/// lobe colour, the two landmark sulci, and the activity of the selected region.
class _BrainPainter extends CustomPainter {
  _BrainPainter({
    required this.selected,
    required this.hovered,
    required this.confidences,
    required this.pulse,
    required this.spread,
    required this.colorFor,
  }) : super(repaint: Listenable.merge([pulse, spread]));

  final LocalizationRegion? selected;
  final LocalizationRegion? hovered;
  final Map<LocalizationRegion, double>? confidences;
  final Animation<double> pulse;
  final Animation<double> spread;
  final Color Function(LocalizationRegion) colorFor;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / _BrainArt.box.width;
    final beat = Curves.easeInOut.transform(pulse.value);
    canvas.save();
    canvas.scale(k);
    canvas.translate(-_BrainArt.box.left, -_BrainArt.box.top);

    // Soft shadow under the specimen.
    canvas.drawOval(
      const Rect.fromLTWH(60, 262, 290, 26),
      Paint()
        ..color = const Color(0x8C000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    _paintBehind(canvas);

    // Everything on the hemisphere is clipped to its outline.
    canvas.save();
    canvas.clipPath(_BrainArt.outline);
    final bounds = _BrainArt.outline.getBounds();
    canvas.drawRect(bounds, Paint()..color = const Color(0xFF2B1D38));

    for (final (path, w) in _BrainArt.gyri) {
      canvas.save();
      canvas.translate(0.8, 1.8);
      canvas.drawPath(path, _stroke(const Color(0xB3120A1C), w + 3));
      canvas.restore();
      canvas.drawPath(path, _stroke(const Color(0xFFB4A2C6), w));
      canvas.save();
      canvas.translate(-1, -1.8);
      canvas.drawPath(path, _stroke(const Color(0x30FFFFFF), w * 0.32));
      canvas.restore();
    }

    // Light from the upper left, shade toward the lower right.
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x26FFFFFF), Color(0x00000000), Color(0x59000000)],
          stops: [0.0, 0.45, 1.0],
        ).createShader(bounds),
    );

    // Lobe colour: hue over the relief, stronger for the hovered and selected lobe.
    final general = selected == LocalizationRegion.generalized;
    for (final entry in _BrainArt.lobes.entries) {
      final region = entry.key;
      final active = selected == region || general;
      final hover = hovered == region;
      final confidence = confidences?[region];
      final color = general ? colorFor(LocalizationRegion.generalized) : colorFor(region);
      var strength = active ? 0.86 : (hover ? 0.66 : 0.4);
      if (confidence != null && active) strength *= 0.6 + 0.4 * confidence;
      for (final path in entry.value) {
        canvas.drawPath(
          path,
          Paint()
            ..blendMode = BlendMode.color
            ..color = color.withValues(alpha: strength),
        );
        if (!active) {
          // lobes that are not selected sit back
          canvas.drawPath(path, Paint()..color = Color.fromRGBO(17, 24, 39, selected == null ? 0.0 : (hover ? 0.12 : 0.38)));
        } else {
          canvas.drawPath(
            path,
            Paint()
              ..blendMode = BlendMode.plus
              ..color = color.withValues(alpha: 0.06 + beat * 0.1),
          );
        }
      }
    }

    // Activity spreading from the focus of the selected region.
    if (selected != null) {
      final origin = _BrainArt.focus[selected]!;
      final color = colorFor(selected!);
      final reach = general ? 250.0 : (selected == LocalizationRegion.insular ? 70.0 : 112.0);
      for (var i = 0; i < 3; i++) {
        final u = (spread.value + i / 3) % 1.0;
        final fade = (1 - u) * (1 - u);
        canvas.drawCircle(
          origin,
          8 + u * reach,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2 + 2.2 * (1 - u)
            ..color = Color.lerp(color, Colors.white, 0.45)!.withValues(alpha: 0.7 * fade),
        );
      }
      canvas.drawCircle(
        origin,
        26 + beat * 10,
        Paint()
          ..shader = RadialGradient(
            colors: [Colors.white.withValues(alpha: 0.5), color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
            stops: const [0.0, 0.4, 1.0],
          ).createShader(Rect.fromCircle(center: origin, radius: 26 + beat * 10)),
      );
    }

    // Landmark sulci.
    for (final sulcus in [_BrainArt.centralSulcus, _BrainArt.lateralSulcus]) {
      canvas.drawPath(sulcus, _stroke(const Color(0xCC140B1E), 4.6));
      canvas.drawPath(sulcus, _stroke(const Color(0xFFE7DBFF), 2.0));
    }
    canvas.restore();

    // Rim: a dark edge, then a thin light on the upper left.
    canvas.drawPath(_BrainArt.outline, _stroke(const Color(0xFF3B2A52), 2.4));
    canvas.save();
    canvas.translate(-0.9, -1.1);
    canvas.drawPath(_BrainArt.outline, _stroke(const Color(0x47FFFFFF), 0.9));
    canvas.restore();

    _paintInsula(canvas, beat);
    canvas.restore();
  }

  void _paintBehind(Canvas canvas) {
    Paint body(Rect r, Color light, Color dark) => Paint()
      ..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [light, dark]).createShader(r);

    final stem = _BrainArt.brainstem.getBounds();
    canvas.drawPath(_BrainArt.brainstem, body(stem, const Color(0xFFD9C3B4), const Color(0xFF8C7468)));
    canvas.drawPath(_BrainArt.brainstem, _stroke(const Color(0x66120A1C), 1.2));

    final cb = _BrainArt.cerebellum.getBounds();
    canvas.drawPath(_BrainArt.cerebellum, body(cb, const Color(0xFFCFA6BC), const Color(0xFF7E5670)));
    canvas.save();
    canvas.clipPath(_BrainArt.cerebellum);
    // folia: a stack of shallow arcs
    for (var y = cb.top + 8; y < cb.bottom; y += 7.5) {
      final arc = Path()
        ..moveTo(cb.left - 4, y + 5)
        ..quadraticBezierTo(cb.center.dx, y - 7, cb.right + 4, y + 5);
      canvas.drawPath(arc, _stroke(const Color(0x73301A30), 1.4));
    }
    canvas.restore();
    canvas.drawPath(_BrainArt.cerebellum, _stroke(const Color(0x66120A1C), 1.2));
  }

  void _paintInsula(Canvas canvas, double beat) {
    final center = _BrainArt.focus[LocalizationRegion.insular]!;
    final active = selected == LocalizationRegion.insular;
    final hover = hovered == LocalizationRegion.insular;
    final color = colorFor(LocalizationRegion.insular);
    final r = _BrainArt.insulaRadius * (active ? 1.0 + beat * 0.14 : 1.0);
    if (active || hover) {
      canvas.drawCircle(
        center,
        r + 7,
        Paint()
          ..color = color.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
    }
    canvas.drawCircle(center, r, Paint()..color = color.withValues(alpha: active ? 0.95 : (hover ? 0.8 : 0.5)));
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.text.withValues(alpha: active ? 0.95 : 0.6),
    );
  }

  static Paint _stroke(Color color, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color;

  @override
  bool shouldRepaint(covariant _BrainPainter oldDelegate) =>
      oldDelegate.selected != selected || oldDelegate.hovered != hovered || oldDelegate.confidences != confidences;
}
