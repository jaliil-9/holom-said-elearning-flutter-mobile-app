import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/colors.dart';

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key,
    this.width = 350,
    this.height = 350,
    this.radius = 350,
    this.padding = 0,
    this.child,
    this.backgroundColor = AppColors.backgroundLight,
  });

  final double? width, height;
  final double radius, padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: backgroundColor.withValues(alpha: 0.1)),
      child: child,
    );
  }
}
