import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import '../../../../core/providers/locale_provider.dart';

class LanguageSelectionPage extends ConsumerWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'إختر لغتك المفضلة',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _LanguageButton(
                language: 'العربية',
                onTap: () async {
                  await ref.read(localeProvider.notifier).setLocale('ar');
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/onboarding');
                  }
                },
                isSelected: currentLocale.languageCode == 'ar',
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              _LanguageButton(
                language: 'English',
                onTap: () async {
                  await ref.read(localeProvider.notifier).setLocale('en');
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/onboarding');
                  }
                },
                isSelected: currentLocale.languageCode == 'en',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String language;
  final VoidCallback onTap;
  final bool isSelected;

  const _LanguageButton({
    required this.language,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Theme.of(context).primaryColor : null,
        ),
        child: Text(
          language,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
