import 'package:flutter/material.dart';
import '../../constants/sizes.dart';
import '../widgets/custom_shimmer.dart';

class ExamShimmerCard extends StatelessWidget {
  const ExamShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            CustomShimmer(
              width: 200,
              height: 20,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: Sizes.xs),

            // Course name
            CustomShimmer(
              width: 150,
              height: 16,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: Sizes.sm),

            // Status and actions row
            Row(
              children: [
                // Status badge
                CustomShimmer(
                  width: 80,
                  height: 24,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const Spacer(),
                // Action buttons
                const CustomShimmer(
                  width: 40,
                  height: 40,
                  shapeBorder: CircleBorder(),
                ),
                const SizedBox(width: Sizes.xs),
                const CustomShimmer(
                  width: 40,
                  height: 40,
                  shapeBorder: CircleBorder(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
