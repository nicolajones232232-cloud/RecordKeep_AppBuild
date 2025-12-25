import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

/// A responsive grid widget that adapts column count and spacing based on screen size
class ResponsiveGrid extends StatelessWidget {
  /// The list of widgets to display in the grid
  final List<Widget> children;

  /// Number of columns to display on mobile devices (width < 600px)
  final int mobileColumns;

  /// Number of columns to display on desktop devices (width >= 600px)
  final int desktopColumns;

  /// The aspect ratio (width / height) for grid items
  final double aspectRatio;

  /// Optional custom spacing override. If null, uses AppSpacing defaults
  final double? spacing;

  /// Whether the grid should shrink wrap its content
  final bool shrinkWrap;

  /// The scroll physics for the grid
  final ScrollPhysics? physics;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.desktopColumns = 2,
    this.aspectRatio = 1.0,
    this.spacing,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isVerySmall = ResponsiveUtils.isVerySmallScreen(context);

    // On very small screens, force single column for better usability
    final columns =
        isVerySmall ? 1 : (isMobile ? mobileColumns : desktopColumns);
    final gridSpacing = spacing ?? AppSpacing.getCardSpacing(context);

    // Constrain content width on very large screens
    final constrainedWidth = ResponsiveUtils.getConstrainedWidth(context);
    final shouldConstrain =
        MediaQuery.of(context).size.width > constrainedWidth;

    Widget grid = GridView.count(
      shrinkWrap: shrinkWrap,
      physics: physics,
      crossAxisCount: columns,
      mainAxisSpacing: gridSpacing,
      crossAxisSpacing: gridSpacing,
      childAspectRatio: aspectRatio,
      children: children,
    );

    // Center content on very large screens
    if (shouldConstrain) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constrainedWidth),
          child: grid,
        ),
      );
    }

    return grid;
  }
}
