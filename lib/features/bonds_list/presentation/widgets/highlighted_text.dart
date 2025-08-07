import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? style;
  final TextStyle? highlightStyle;

  const HighlightedText({
    Key? key,
    required this.text,
    required this.query,
    this.style,
    this.highlightStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();
    final matches = <int>[];

    // Find all matches
    int index = 0;
    while (index < textLower.length) {
      final matchIndex = textLower.indexOf(queryLower, index);
      if (matchIndex == -1) break;
      
      for (int i = matchIndex; i < matchIndex + queryLower.length; i++) {
        matches.add(i);
      }
      index = matchIndex + 1;
    }

    if (matches.isEmpty) {
      return Text(text, style: style);
    }

    final spans = <TextSpan>[];
    for (int i = 0; i < text.length; i++) {
      if (matches.contains(i)) {
        spans.add(TextSpan(
          text: text[i],
          style: highlightStyle ?? style?.copyWith(
            backgroundColor: Colors.orange[100],
            fontWeight: FontWeight.w600,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: text[i],
          style: style,
        ));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
