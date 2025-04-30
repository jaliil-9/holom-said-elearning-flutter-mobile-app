import 'package:flutter/material.dart';
import 'package:holom_said/core/constants/sizes.dart';
import '../../../../generated/l10n.dart';
import 'setting_builds.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).aboutUs),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingBuilds.buildSection(
              context,
              S.of(context).mission,
              [
                SettingBuilds.buildInfoCard(
                  context,
                  S.of(context).onboardingTitle1,
                  S.of(context).onboardingDesc1,
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            SettingBuilds.buildSection(
              context,
              S.of(context).goals,
              [
                SettingBuilds.buildInfoCard(
                  context,
                  S.of(context).onboardingTitle2,
                  S.of(context).onboardingDesc2,
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            SettingBuilds.buildSection(
              context,
              S.of(context).values,
              [
                SettingBuilds.buildInfoCard(
                  context,
                  S.of(context).onboardingTitle3,
                  S.of(context).onboardingDesc3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
