import 'package:flutter/material.dart';
import '../../constants/sizes.dart';
import '../../../generated/l10n.dart';

class CustomErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/error.png',
              width: 150,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              S.of(context).errorLoadingData,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: onRetry,
              label: Text(S.of(context).retryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
