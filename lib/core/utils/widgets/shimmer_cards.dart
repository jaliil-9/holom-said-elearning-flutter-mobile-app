import 'package:flutter/material.dart';
import '../../constants/sizes.dart';
import 'custom_shimmer.dart';

class EventShimmerCard extends StatelessWidget {
  const EventShimmerCard({super.key});

  @override
  Widget build(BuildContext context) => CustomShimmer(
        height: 180,
        width: double.infinity,
        shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        ),
      );
}

class HomeTrainerShimmerCard extends StatelessWidget {
  const HomeTrainerShimmerCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: 100,
        margin: const EdgeInsets.only(right: Sizes.spaceBtwItems),
        child: Column(
          children: [
            CustomShimmer(
              height: 70,
              width: 70,
              shapeBorder: const CircleBorder(),
            ),
            const SizedBox(height: Sizes.spaceBtwItems / 2),
            CustomShimmer(
              height: 14,
              width: 80,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.borderRadiusSm),
              ),
            ),
            const SizedBox(height: 4),
            CustomShimmer(
              height: 12,
              width: 60,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.borderRadiusSm),
              ),
            ),
          ],
        ),
      );
}

class HomeCourseShimmerCard extends StatelessWidget {
  const HomeCourseShimmerCard({super.key});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceBtwItems),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          height: 16,
                          width: double.infinity,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Sizes.borderRadiusSm),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomShimmer(
                          height: 14,
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
            ],
          ),
        ),
      );
}
