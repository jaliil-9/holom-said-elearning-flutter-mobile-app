import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import 'setting_builds.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).helpCenter),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingBuilds.buildSection(
              context,
              S.of(context).faq,
              [
                SettingBuilds.buildExpandableTile(
                  context,
                  S.of(context).faqQuestion1,
                  S.of(context).faqAnswer1,
                ),
                SettingBuilds.buildExpandableTile(
                  context,
                  S.of(context).faqQuestion2,
                  S.of(context).faqAnswer2,
                ),
                SettingBuilds.buildExpandableTile(
                  context,
                  S.of(context).faqQuestion3,
                  S.of(context).faqAnswer3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
