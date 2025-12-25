import 'package:flutter/material.dart';

/// Centralized responsive utilities for breakpoint detection and responsive values
class ResponsiveUtils {
  static const double mobileBreakpoint = 600.0;
  static const double minViewportWidth = 320.0;
  static const double maxContentWidth = 1920.0;

  /// Returns true if the current viewport width is less than 600 pixels
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Returns true if the current viewport width is 600 pixels or greater
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint;
  }

  /// Returns true if the viewport is very small (< 320px)
  static bool isVerySmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < minViewportWidth;
  }

  /// Returns true if the viewport is very large (> 1920px)
  static bool isVeryLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > maxContentWidth;
  }

  /// Returns the constrained width for content on very large screens
  /// Returns the actual width for normal screens
  static double getConstrainedWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > maxContentWidth) {
      return maxContentWidth;
    }
    return width;
  }

  /// Returns a responsive value based on the current viewport size
  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    required double desktop,
  }) {
    return isMobile(context) ? mobile : desktop;
  }

  /// Returns a responsive value of any type based on the current viewport size
  static T getResponsiveValueGeneric<T>(
    BuildContext context, {
    required T mobile,
    required T desktop,
  }) {
    return isMobile(context) ? mobile : desktop;
  }
}

/// Spacing constants for mobile and desktop layouts
class AppSpacing {
  // Mobile spacing
  static const double mobileScreenPadding = 12.0;
  static const double mobileCardSpacing = 8.0;
  static const double mobileFormFieldSpacing = 16.0;
  static const double mobileSectionSpacing = 24.0;
  static const double mobileFilterSpacing = 12.0;

  // Desktop spacing
  static const double desktopScreenPadding = 16.0;
  static const double desktopCardSpacing = 12.0;
  static const double desktopFormFieldSpacing = 16.0;
  static const double desktopSectionSpacing = 24.0;

  // Touch targets
  static const double minTouchTarget = 44.0;
  static const double minButtonHeight = 48.0;

  // FAB positioning
  static const double fabMargin = 16.0;
  static const double fabSpacing = 12.0;

  /// Get responsive screen padding based on context
  static double getScreenPadding(BuildContext context) {
    return ResponsiveUtils.isMobile(context)
        ? mobileScreenPadding
        : desktopScreenPadding;
  }

  /// Get responsive card spacing based on context
  static double getCardSpacing(BuildContext context) {
    return ResponsiveUtils.isMobile(context)
        ? mobileCardSpacing
        : desktopCardSpacing;
  }

  /// Get responsive form field spacing based on context
  static double getFormFieldSpacing(BuildContext context) {
    return ResponsiveUtils.isMobile(context)
        ? mobileFormFieldSpacing
        : desktopFormFieldSpacing;
  }

  /// Get responsive section spacing based on context
  static double getSectionSpacing(BuildContext context) {
    return ResponsiveUtils.isMobile(context)
        ? mobileSectionSpacing
        : desktopSectionSpacing;
  }
}

/// Typography scale constants for mobile and desktop
class AppTypography {
  // Mobile typography
  static const double mobileBodyText = 14.0;
  static const double mobileLabel = 12.0;
  static const double mobileHeading1 = 24.0;
  static const double mobileHeading2 = 20.0;
  static const double mobileHeading3 = 16.0;

  // Desktop typography
  static const double desktopBodyText = 14.0;
  static const double desktopLabel = 13.0;
  static const double desktopHeading1 = 32.0;
  static const double desktopHeading2 = 24.0;
  static const double desktopHeading3 = 18.0;

  // Line height
  static const double lineHeight = 1.4;

  /// Get responsive body text size based on context
  static double getBodyTextSize(BuildContext context) {
    return ResponsiveUtils.isMobile(context) ? mobileBodyText : desktopBodyText;
  }

  /// Get responsive label size based on context
  static double getLabelSize(BuildContext context) {
    return ResponsiveUtils.isMobile(context) ? mobileLabel : desktopLabel;
  }

  /// Get responsive heading 1 size based on context
  static double getHeading1Size(BuildContext context) {
    return ResponsiveUtils.isMobile(context) ? mobileHeading1 : desktopHeading1;
  }

  /// Get responsive heading 2 size based on context
  static double getHeading2Size(BuildContext context) {
    return ResponsiveUtils.isMobile(context) ? mobileHeading2 : desktopHeading2;
  }

  /// Get responsive heading 3 size based on context
  static double getHeading3Size(BuildContext context) {
    return ResponsiveUtils.isMobile(context) ? mobileHeading3 : desktopHeading3;
  }

  /// Get TextStyle for body text with proper line height
  static TextStyle getBodyTextStyle(
    BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: getBodyTextSize(context),
      height: lineHeight,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Get TextStyle for label text with proper line height
  static TextStyle getLabelStyle(
    BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: getLabelSize(context),
      height: lineHeight,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Get TextStyle for heading 1 with proper line height
  static TextStyle getHeading1Style(
    BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: getHeading1Size(context),
      height: lineHeight,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
    );
  }

  /// Get TextStyle for heading 2 with proper line height
  static TextStyle getHeading2Style(
    BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: getHeading2Size(context),
      height: lineHeight,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
    );
  }

  /// Get TextStyle for heading 3 with proper line height
  static TextStyle getHeading3Style(
    BuildContext context, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: getHeading3Size(context),
      height: lineHeight,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color,
    );
  }
}

/// Icon size constants for different contexts
class AppIconSizes {
  static const double listItem = 24.0;
  static const double button = 20.0;
  static const double appBar = 24.0;
  static const double fab = 24.0;
  static const double cardDecorative = 28.0; // Mobile
  static const double cardDecorativeLarge = 36.0; // Desktop

  /// Get responsive card decorative icon size based on context
  static double getCardDecorativeSize(BuildContext context) {
    return ResponsiveUtils.isMobile(context)
        ? cardDecorative
        : cardDecorativeLarge;
  }
}
