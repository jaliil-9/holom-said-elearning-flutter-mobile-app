import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  static List<OnboardingModel> getItems(BuildContext context) {
    return [
      OnboardingModel(
        title: S.of(context).onboardingTitle1,
        description: S.of(context).onboardingDesc1,
        imagePath: 'assets/images/onboarding/onboarding1.jpg',
      ),
      OnboardingModel(
        title: S.of(context).onboardingTitle2,
        description: S.of(context).onboardingDesc2,
        imagePath: 'assets/images/onboarding/onboarding2.jpg',
      ),
      OnboardingModel(
        title: S.of(context).onboardingTitle3,
        description: S.of(context).onboardingDesc3,
        imagePath: 'assets/images/onboarding/onboarding3.jpg',
      ),
    ];
  }
}
