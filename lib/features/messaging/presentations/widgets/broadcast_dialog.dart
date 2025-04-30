import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import '../../../../generated/l10n.dart';
import '../../../personalzation/providers/profile_providers.dart';
import '../../models/message_model.dart';
import '../../providers/messages_provider.dart';

class BroadcastDialog extends ConsumerStatefulWidget {
  const BroadcastDialog({super.key});

  @override
  ConsumerState<BroadcastDialog> createState() => _BroadcastDialogState();
}

class _BroadcastDialogState extends ConsumerState<BroadcastDialog> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).broadcastMessage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: S.of(context).subject,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: S.of(context).message,
                border: const OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(S.of(context).cancel),
                ),
                ElevatedButton(
                  onPressed: _sendBroadcast,
                  child: Text(S.of(context).send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendBroadcast() async {
    if (_subjectController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      return;
    }
    final admin = ref.read(adminProfileProvider).value;

    final message = Message(
      senderId: admin!.id,
      content: _messageController.text.trim(),
      subject: _subjectController.text.trim(),
      type: MessageType.broadcast,
      senderName: admin.firstname,
      isAdminSender: true,
    );

    await ref.read(messagesNotifierProvider.notifier).sendMessage(message);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
