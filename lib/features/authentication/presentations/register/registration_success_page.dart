import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../generated/l10n.dart';

class RegistrationSuccessPage extends StatelessWidget {
  const RegistrationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.tick_circle,
                size: 100,
                color: isDarkMode
                    ? AppColors.secondaryDark
                    : AppColors.secondaryLight),
            const SizedBox(height: Sizes.spaceBtwSections),
            Text(
              S.of(context).accountCreatedTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              S.of(context).accountCreatedMessage,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/user-home-page'),
                child: Text(S.of(context).login),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
