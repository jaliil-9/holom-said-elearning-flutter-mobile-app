import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/widgets/custom_shimmer.dart';

class UserShimmerCard extends StatelessWidget {
  const UserShimmerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomShimmer(
                width: 60,
                height: 60,
                shapeBorder: const CircleBorder(),
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CustomShimmer(
                  width: 150,
                  height: 20,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmer(
                    width: 200,
                    height: 16,
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
              trailing: CustomShimmer(
                width: 24,
                height: 24,
                shapeBorder: const CircleBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
