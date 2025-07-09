import 'package:flutter/material.dart';

class ShowMoreText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? textStyle;

  const ShowMoreText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.textStyle,
  });

  @override
  State<ShowMoreText> createState() => _ShowMoreTextState();
}

class _ShowMoreTextState extends State<ShowMoreText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.textStyle ?? const TextStyle(color: Colors.black);

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: _isExpanded ? null : widget.maxLines,
              overflow: TextOverflow.fade,
              style: textStyle,
            ),
            if (isOverflowing)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Show less' : 'Show more',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
          ],
        );
      },
    );
  }
}
