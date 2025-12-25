import 'package:flutter/material.dart';

/// A widget that displays text with ellipsis truncation and tap-to-expand functionality.
///
/// When the text exceeds the specified [maxLines], it will be truncated with an ellipsis.
/// Tapping the truncated text will expand it to show the full content.
/// Tapping again will collapse it back to the truncated state.
class ExpandableText extends StatefulWidget {
  /// The text to display
  final String text;

  /// Maximum number of lines to show when collapsed
  final int maxLines;

  /// Text style to apply
  final TextStyle? style;

  /// Text alignment
  final TextAlign? textAlign;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.style,
    this.textAlign,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Handle edge case of very narrow constraints
        final effectiveMaxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 32; // Fallback with padding

        // Create a TextPainter to measure if text overflows
        final textSpan = TextSpan(
          text: widget.text,
          style: widget.style ?? DefaultTextStyle.of(context).style,
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
          textAlign: widget.textAlign ?? TextAlign.start,
        );

        textPainter.layout(maxWidth: effectiveMaxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return GestureDetector(
          onTap: isOverflowing
              ? () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }
              : null,
          child: Text(
            widget.text,
            style: widget.style,
            textAlign: widget.textAlign,
            maxLines: _isExpanded ? null : widget.maxLines,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            // Ensure text wraps properly without horizontal overflow
            softWrap: true,
          ),
        );
      },
    );
  }
}
