import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_shimmer.dart';

class HomeCountWidget extends ConsumerWidget {
  final AsyncValue<List<dynamic>> value;
  final Color color;
  final double fontSize;

  const HomeCountWidget({
    super.key,
    required this.value,
    required this.color,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return value.when(
      data: (data) => Text(
        data.length.toString(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      loading: () => CustomShimmer(
        width: 50,
        height: fontSize,
        shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      error: (error, _) => Text(
        '0',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
