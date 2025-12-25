import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

/// A responsive empty state widget that scales appropriately across screen sizes
class ResponsiveEmptyState extends StatelessWidget {
  /// The icon to display
  final IconData icon;

  /// The title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Optional action button
  final Widget? action;

  /// Icon color
  final Color? iconColor;

  const ResponsiveEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isVerySmall = ResponsiveUtils.isVerySmallScreen(context);

    // Scale icon size based on screen size
    final iconSize = isVerySmall ? 64.0 : (isMobile ? 80.0 : 100.0);

    // Scale padding based on screen size
    final padding = isVerySmall ? 16.0 : (isMobile ? 24.0 : 32.0);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? Colors.grey.shade400,
            ),
            SizedBox(height: isVerySmall ? 12 : 16),
            Text(
              title,
              style: AppTypography.getHeading2Style(
                context,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: isVerySmall ? 6 : 8),
              Text(
                subtitle!,
                style: AppTypography.getBodyTextStyle(
                  context,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: isVerySmall ? 16 : 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
