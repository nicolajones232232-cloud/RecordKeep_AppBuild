import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/responsive_utils.dart';

/// A responsive floating action button that follows mobile UI optimization guidelines
/// - Positioned with 16px margin from edges
/// - Icon size of 24px
/// - Haptic feedback on tap
class ResponsiveFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String? tooltip;
  final String? heroTag;
  final bool mini;

  const ResponsiveFAB({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
    this.heroTag,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.fabMargin),
      child: FloatingActionButton(
        heroTag: heroTag,
        mini: mini,
        onPressed: () {
          // Trigger haptic feedback on supported devices
          HapticFeedback.lightImpact();
          onPressed();
        },
        tooltip: tooltip,
        child: child,
      ),
    );
  }
}

/// A widget for stacking multiple FABs vertically with proper spacing
class StackedFABs extends StatelessWidget {
  final List<Widget> fabs;

  const StackedFABs({super.key, required this.fabs});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: _buildFABsWithSpacing(),
    );
  }

  List<Widget> _buildFABsWithSpacing() {
    final List<Widget> widgets = [];
    for (int i = 0; i < fabs.length; i++) {
      widgets.add(fabs[i]);
      if (i < fabs.length - 1) {
        widgets.add(const SizedBox(height: AppSpacing.fabSpacing));
      }
    }
    return widgets;
  }
}
