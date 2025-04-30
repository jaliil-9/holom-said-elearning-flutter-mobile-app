import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../generated/l10n.dart';
import '../../../messaging/models/message_model.dart';
import '../../../messaging/providers/messages_provider.dart';
import '../../providers/profile_providers.dart';
import 'setting_builds.dart';

class ContactUsPage extends ConsumerWidget {
  ContactUsPage({super.key});
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void sendMessage() async {
      if (_messageController.text.trim().isEmpty &&
          _subjectController.text.trim().isEmpty) {
        return;
      }

      try {
        final user = ref.read(userProfileProvider).value;

        final message = Message(
          senderId: user!.id,
          receiverId: null, // For all admins
          content: _messageController.text.trim(),
          subject: _subjectController.text.trim(),
          type: MessageType.individual,
          senderName: '${user.firstname} ${user.lastname}',
          senderProfileUrl: user.profilePicture,
          isAdminSender: false,
        );

        await ref.read(messagesNotifierProvider.notifier).sendMessage(message);
        _subjectController.clear();
        _messageController.clear();

        // ignore: use_build_context_synchronously
        ErrorUtils.showSuccessSnackBar(S.of(context).messageSent);
      } catch (e) {
        ErrorUtils.showErrorSnackBar(ErrorUtils.getErrorMessage(e));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).contactUs),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contact Information
            SettingBuilds.buildSection(
              context,
              S.of(context).contactInfo,
              [
                SettingBuilds.buildTile(
                  context,
                  Iconsax.message,
                  S.of(context).email,
                  subtitle: 'HolomSaid@gmail.com',
                  onTap: () => _launchUrl('mailto:HolomSaid@gmail.com'),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            // Social Media
            SettingBuilds.buildSection(
              context,
              S.of(context).socialMedia,
              [
                SettingBuilds.buildTile(
                  context,
                  Icons.facebook,
                  'Facebook',
                  onTap: () =>
                      _launchUrl('https://www.facebook.com/HolomSaid/'),
                ),
                SettingBuilds.buildTile(
                  context,
                  Iconsax.instagram,
                  'Instagram',
                  onTap: () => _launchUrl(
                      'https://www.instagram.com/holomsaid?igsh=bWF0bXh1dm9mNmZp'),
                ),
                SettingBuilds.buildTile(
                  context,
                  Iconsax.message_programming,
                  'Telegram',
                  onTap: () => _launchUrl('https://t.me/+lqYex9_SBWw3NDU0'),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            // Contact Form
            SettingBuilds.buildSection(
              context,
              S.of(context).sendMessage,
              [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.defaultSpace),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            labelText: S.of(context).subject,
                            prefixIcon: const Icon(Iconsax.message_text),
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceBtwInputFields),
                        TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            labelText: S.of(context).message,
                            prefixIcon: const Icon(Iconsax.message_text),
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: Sizes.spaceBtwSections),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => sendMessage(),
                            child: Text(S.of(context).send),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
