import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// The reusable rounded, bordered "ink" card used across every screen —
/// equivalent to ICUCalc's `.card` treatment. Optionally lifts and glows on
/// hover (desktop/web) via [hoverable].
class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s5),
    this.onTap,
    this.borderColor,
    this.glow = false,
    this.hoverable = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? borderColor;
  final bool glow;

  /// When true, the card lifts a few pixels and its border/glow brighten on
  /// mouse hover (desktop/web pointer). No-op on touch-only devices.
  final bool hoverable;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovering = false;
  bool _pressed = false;

  void _setHover(bool value) {
    if (widget.hoverable && _hovering != value) {
      setState(() => _hovering = value);
    }
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final lifted = widget.hoverable && _hovering;
    final accent = widget.borderColor ?? AppColors.brand3;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, lifted ? -5 : 0, 0),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: AppColors.ink800,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(
          color: lifted ? accent.withValues(alpha: 0.6) : (widget.borderColor ?? AppColors.line),
        ),
        boxShadow: (widget.glow || lifted)
            ? [
                BoxShadow(
                  color: AppColors.brand3.withValues(alpha: lifted ? 0.26 : 0.18),
                  blurRadius: lifted ? 34 : 28,
                  spreadRadius: -8,
                  offset: const Offset(0, 14),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: widget.child,
    );

    Widget result = card;
    if (widget.onTap != null) {
      result = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapCancel: () => _setPressed(false),
          onTapUp: (_) => _setPressed(false),
          child: card,
        ),
      );
    }

    result = AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: result,
    );

    if (!widget.hoverable) return result;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: result,
    );
  }
}
