import 'package:flutter/material.dart';

class WordWrapText extends StatelessWidget {
  const WordWrapText({
    super.key,
    required this.fullText, // Full original sentence
    this.wrongWord = '', // Word to highlight (optional)
    this.textAlign = TextAlign.center,
    this.baseStyle,
    this.highlightStyle,
  });

  final String fullText;
  final String wrongWord;
  final TextAlign textAlign;
  final TextStyle? baseStyle;
  final TextStyle? highlightStyle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<InlineSpan> currentLineSpans = [];
        List<TextSpan> outputLines = [];

        // Determine effective styles
        final effectiveBaseStyle = baseStyle ?? DefaultTextStyle.of(context).style;
        final effectiveHighlightStyle = highlightStyle ?? effectiveBaseStyle.copyWith(
          color: const Color(0xFFE57373), // 문제 페이지의 하이라이트 색상과 동일하게 설정
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFFE57373),
          decorationThickness: 2.0,
        );

        // Split the full text into parts, handling the wrongWord for highlighting
        final int wrongWordStart = (wrongWord.isNotEmpty) ? fullText.indexOf(wrongWord) : -1; // wrongWord가 있을 때만 인덱스 찾기

        List<TextSpan> spansWithHighlighting = [];
        if (wrongWordStart != -1) {
          if (wrongWordStart > 0) {
            spansWithHighlighting.add(TextSpan(text: fullText.substring(0, wrongWordStart), style: effectiveBaseStyle));
          }
          spansWithHighlighting.add(TextSpan(text: wrongWord, style: effectiveHighlightStyle));
          if (wrongWordStart + wrongWord.length < fullText.length) {
            spansWithHighlighting.add(TextSpan(text: fullText.substring(wrongWordStart + wrongWord.length), style: effectiveBaseStyle));
          }
        } else {
          spansWithHighlighting.add(TextSpan(text: fullText, style: effectiveBaseStyle));
        }

        // Helper function to get parts (words and spaces)
        List<String> getParts(String text) {
          List<String> parts = [];
          RegExp wordAndSpace = RegExp(r'(\S+|\s+)'); // Match words or spaces
          for (RegExpMatch m in wordAndSpace.allMatches(text)) {
            parts.add(m.group(0)!);
          }
          return parts;
        }

        // Process each generated TextSpan
        for (final textSpan in spansWithHighlighting) {
          if (textSpan.text == null || textSpan.text!.isEmpty) continue;

          final wordsAndSpaces = getParts(textSpan.text!);

          for (final part in wordsAndSpaces) {
            final isSpace = RegExp(r'^\s+$').hasMatch(part);
            final spanToAdd = TextSpan(text: part, style: isSpace ? effectiveBaseStyle : textSpan.style);

            TextPainter tp = TextPainter(
              text: TextSpan(
                style: effectiveBaseStyle, // Use base style for measurement consistency
                children: [...currentLineSpans, spanToAdd],
              ),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);

            if (tp.didExceedMaxLines && currentLineSpans.isNotEmpty) {
              outputLines.add(TextSpan(style: effectiveBaseStyle, children: currentLineSpans));
              currentLineSpans = [spanToAdd];
            } else {
              currentLineSpans.add(spanToAdd);
            }
          }
        }

        if (currentLineSpans.isNotEmpty) {
          outputLines.add(TextSpan(style: effectiveBaseStyle, children: currentLineSpans));
        }

        final List<InlineSpan> finalSpans = [];
        for (int i = 0; i < outputLines.length; i++) {
          finalSpans.add(outputLines[i]);
          if (i < outputLines.length - 1) {
            finalSpans.add(const TextSpan(text: '\n'));
          }
        }

        return RichText(
          text: TextSpan(
            style: effectiveBaseStyle, // Main RichText should use effectiveBaseStyle
            children: finalSpans,
          ),
          textAlign: textAlign,
        );
      },
    );
  }
} 