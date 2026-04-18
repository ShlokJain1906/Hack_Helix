import 'package:flutter/material.dart';

/// Breakpoints and responsive utilities for adaptive layouts.
class Responsive {
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;

  final BuildContext context;
  late final Size _size;
  late final double _width;

  Responsive(this.context) {
    _size = MediaQuery.sizeOf(context);
    _width = _size.width;
  }

  bool get isMobile => _width < tabletBreakpoint;
  bool get isTablet => _width >= tabletBreakpoint && _width < desktopBreakpoint;
  bool get isDesktop => _width >= desktopBreakpoint;

  double get width => _width;
  double get height => _size.height;

  /// Number of grid columns for emergency cards
  int get gridColumns {
    if (_width >= desktopBreakpoint) return 4;
    if (_width >= tabletBreakpoint) return 3;
    return 2;
  }

  /// Max content width to prevent ultra-wide stretching
  double get maxContentWidth {
    if (isDesktop) return 600;
    if (isTablet) return 500;
    return _width;
  }

  /// Horizontal padding that scales with screen size
  double get horizontalPadding {
    if (isDesktop) return 32;
    if (isTablet) return 24;
    return 16;
  }

  /// Scale factor for font sizes
  double get fontScale {
    if (isDesktop) return 1.15;
    if (isTablet) return 1.08;
    return 1.0;
  }

  /// Scales vertical spacing proportionally to screen height.
  /// Reference height: 812 (iPhone X/11/12 logical height).
  double vPad(double value) {
    const referenceHeight = 812.0;
    final scale = (_size.height / referenceHeight).clamp(0.65, 1.3);
    return value * scale;
  }

  /// Minimum touch target size (Material 3 guideline: 48px)
  static const double minTouchTarget = 48.0;

  /// Wraps content in a centered, max-width container for wide screens
  static Widget constrain({required Widget child, double maxWidth = 600}) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
