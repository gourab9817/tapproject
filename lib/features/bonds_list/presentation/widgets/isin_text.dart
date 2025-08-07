import 'package:flutter/material.dart';

class IsinText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle baseStyle;
  final TextStyle? bigStyle;
  final TextStyle? highlightStyle;
  final int lastN;

  const IsinText({
    Key? key,
    required this.text,
    required this.query,
    required this.baseStyle,
    this.bigStyle,
    this.highlightStyle,
    this.lastN = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveHighlight = highlightStyle ?? baseStyle.copyWith(
      backgroundColor: Colors.orange[100],
      fontWeight: FontWeight.w600,
    );

    final effectiveBig = bigStyle ?? baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 16) + 2,
      fontWeight: FontWeight.w800,
    );

    // Build set of indices that match the query for highlighting
    final Set<int> matchIndices = {};
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      final t = text.toLowerCase();
      int i = 0;
      while (i < t.length) {
        final idx = t.indexOf(q, i);
        if (idx == -1) break;
        for (int j = idx; j < idx + q.length && j < t.length; j++) {
          matchIndices.add(j);
        }
        i = idx + 1;
      }
    }

    final int startBig = text.length - lastN < 0 ? 0 : text.length - lastN;
    final spans = <TextSpan>[];

    for (int i = 0; i < text.length; i++) {
      TextStyle style = i >= startBig ? effectiveBig : baseStyle;
      if (matchIndices.contains(i)) {
        style = style.merge(effectiveHighlight);
      }
      spans.add(TextSpan(text: text[i], style: style));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
