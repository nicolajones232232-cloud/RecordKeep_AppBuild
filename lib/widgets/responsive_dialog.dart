import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

/// A responsive dialog wrapper that adapts to mobile and desktop viewports
///
/// On mobile:
/// - Height constrained to 90% of viewport
/// - Scrollable content area with fixed footer
/// - Full width
///
/// On desktop:
/// - Max width of 600px
/// - Standard dialog behavior
class ResponsiveDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const ResponsiveDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isVerySmall = ResponsiveUtils.isVerySmallScreen(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // On very small screens, use more of the viewport (95%)
    // On normal mobile, use 90%
    final maxHeight = isVerySmall ? screenHeight * 0.95 : screenHeight * 0.9;

    // On very small screens, use full width with minimal padding
    // On normal mobile, use full width
    // On desktop, constrain to 600px max
    final maxWidth = isVerySmall
        ? screenWidth - 16 // 8px padding on each side
        : (isMobile ? double.infinity : 600.0);

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          minHeight: 200, // Ensure minimum usable height
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title section with reduced padding on very small screens
            Padding(
              padding: EdgeInsets.all(isVerySmall ? 12 : 16),
              child: title,
            ),
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isVerySmall ? 12 : 16,
                ),
                child: content,
              ),
            ),
            // Action buttons - fixed footer on mobile, inline on desktop
            if (isMobile)
              _buildFixedFooter(actions, isVerySmall)
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a fixed footer with shadow for mobile dialogs
  Widget _buildFixedFooter(List<Widget> actions, bool isVerySmall) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.all(isVerySmall ? 12 : 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
    );
  }
}
