import 'package:flutter/material.dart';

/// A card wrapper that adds a subtle scale-down + glow effect on press/hover.
/// Keeps the animation lightweight — no layout shift, no size bloat.
class AnimatedPressCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final Color glowColor;
  final double pressScale;

  const AnimatedPressCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.glowColor = const Color(0x20FFFFFF),
    this.pressScale = 0.97,
  });

  @override
  State<AnimatedPressCard> createState() => _AnimatedPressCardState();
}

class _AnimatedPressCardState extends State<AnimatedPressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: widget.pressScale).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnim.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: widget.glowColor.withValues(
                        alpha: (widget.glowColor.a * _glowAnim.value),
                      ),
                      blurRadius: 12 * _glowAnim.value,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: child,
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
