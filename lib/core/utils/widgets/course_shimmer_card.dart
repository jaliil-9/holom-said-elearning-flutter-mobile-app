import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/custom_shimmer.dart';

class CourseShimmerCard extends StatelessWidget {
  final bool isAdmin;

  const CourseShimmerCard({
    super.key,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.md),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          children: [
            Row(
              children: [
                CustomShimmer(
                  height: 68,
                  width: 68,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(
                        height: 20,
                        width: 200,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Sizes.borderRadiusSm),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomShimmer(
                        height: 16,
                        width: 150,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Sizes.borderRadiusSm),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isAdmin) ...[
              const SizedBox(height: Sizes.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    child: CustomShimmer(
                      height: 40,
                      width: 80,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Sizes.borderRadiusSm),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sizes.sm),
                  Expanded(
                    child: CustomShimmer(
                      height: 40,
                      width: 80,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Sizes.borderRadiusSm),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
