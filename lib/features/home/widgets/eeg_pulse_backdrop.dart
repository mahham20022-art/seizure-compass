import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A wide, faint EEG trace with a bright pulse continuously traveling
/// along it — sits behind the hero logo so the mark reads as "live"
/// without redrawing the logo's own painter.
class EegPulseBackdrop extends StatefulWidget {
  const EegPulseBackdrop({super.key, this.width = 260, this.height = 72});

  final double width;
  final double height;

  @override
  State<EegPulseBackdrop> createState() => _EegPulseBackdropState();
}

class _EegPulseBackdropState extends State<EegPulseBackdrop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(painter: _EegPainter(_controller.value)),
      ),
    );
  }
}

class _EegPainter extends CustomPainter {
  _EegPainter(this.t);

  final double t;

  Path _tracePath(Size size) {
    final w = size.width;
    final midY = size.height / 2;
    return Path()
      ..moveTo(0, midY)
      ..lineTo(w * 0.10, midY)
      ..lineTo(w * 0.18, midY - size.height * 0.32)
      ..lineTo(w * 0.24, midY + size.height * 0.38)
      ..lineTo(w * 0.30, midY)
      ..lineTo(w * 0.46, midY)
      ..lineTo(w * 0.52, midY - size.height * 0.4)
      ..lineTo(w * 0.58, midY + size.height * 0.3)
      ..lineTo(w * 0.66, midY)
      ..lineTo(w * 0.82, midY)
      ..lineTo(w * 0.88, midY - size.height * 0.3)
      ..lineTo(w * 0.94, midY + size.height * 0.34)
      ..lineTo(w, midY);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _tracePath(size);

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.line2.withValues(alpha: 0.4);
    canvas.drawPath(path, basePaint);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: const [Colors.transparent, AppColors.pnes, Colors.transparent],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment(-1.0 + t * 3, 0),
        end: Alignment(-0.4 + t * 3, 0),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _EegPainter oldDelegate) => oldDelegate.t != t;
}
