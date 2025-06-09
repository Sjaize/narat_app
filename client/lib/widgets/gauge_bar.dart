import 'package:flutter/material.dart';

class GaugeBar extends StatelessWidget {
  final double percentage;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final double borderRadius;

  const GaugeBar({
    super.key,
    required this.percentage,
    this.backgroundColor = const Color(0xFFFDE68A), // 카드 테두리 색상과 동일하게
    this.foregroundColor = const Color(0xFF2D2A1E), // 텍스트 색상과 동일하게
    this.height = 8.0,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage / 100,
        child: Container(
          decoration: BoxDecoration(
            color: foregroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
} 