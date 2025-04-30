import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/custom_shimmer.dart';

class TrainerShimmerCard extends StatelessWidget {
  const TrainerShimmerCard({
    super.key,
    this.isAdmin = false,
  });
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Sizes.defaultSpace,
        vertical: Sizes.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Sizes.sm),
                  child: CustomShimmer(
                    width: 60,
                    height: 60,
                    shapeBorder: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: Sizes.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(
                        width: 150,
                        height: 20,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomShimmer(
                        width: 100,
                        height: 16,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            isAdmin ? const SizedBox(height: Sizes.spaceBtwItems) : SizedBox(),
            isAdmin
                ? Row(
                    children: [
                      Expanded(
                        child: CustomShimmer(
                          width: double.infinity,
                          height: 40,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: Sizes.sm),
                      Expanded(
                        child: CustomShimmer(
                          width: double.infinity,
                          height: 40,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
