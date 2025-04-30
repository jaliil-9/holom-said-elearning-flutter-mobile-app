import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/custom_shimmer.dart';

class ReviewOverviewShimmer extends StatelessWidget {
  const ReviewOverviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomShimmer(width: 120, height: 24),
                CustomShimmer(width: 80, height: 24),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CustomShimmer(width: 40, height: 32),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: CustomShimmer(
                        width: 20,
                        height: 20,
                        shapeBorder: const CircleBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CustomShimmer(
                  width: 32,
                  height: 32,
                  shapeBorder: const CircleBorder(),
                ),
                const SizedBox(width: 8),
                CustomShimmer(width: 120, height: 16),
              ],
            ),
            const SizedBox(height: 8),
            CustomShimmer(
              width: double.infinity,
              height: 16,
            ),
            const SizedBox(height: 4),
            CustomShimmer(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewCardShimmer extends StatelessWidget {
  const ReviewCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomShimmer(
                  width: 40,
                  height: 40,
                  shapeBorder: const CircleBorder(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(width: 120, height: 16),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: CustomShimmer(
                              width: 16,
                              height: 16,
                              shapeBorder: const CircleBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomShimmer(
              width: double.infinity,
              height: 16,
            ),
            const SizedBox(height: 4),
            CustomShimmer(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
