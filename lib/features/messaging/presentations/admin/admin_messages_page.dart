import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../generated/l10n.dart';
import '../../models/message_model.dart';
import '../../providers/messages_provider.dart';
import 'admin_chat_room_page.dart';
import '../widgets/message_list_tile.dart';
import '../widgets/broadcast_dialog.dart';

class AdminMessagesPage extends ConsumerWidget {
  const AdminMessagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(adminMessagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).messages),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.message_add),
            onPressed: () => _showBroadcastDialog(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh the messages
          return ref.refresh(adminMessagesProvider);
        },
        child: messages.when(
          data: (msgs) => _buildMessagesList(context, msgs, ref),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(
            child: Text(S.of(context).errorLoadingData),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesList(
      BuildContext context, List<Message> messages, WidgetRef ref) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.message_text,
              size: 48,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              S.of(context).noMessages,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ],
        ),
      );
    }

    // Filter out admin messages and keep the latest message from each use
    final Map<String, Message> latestMessages = {};
    for (var message in messages.where((m) => !m.isAdminSender)) {
      final senderId = message.senderId;
      if (!latestMessages.containsKey(senderId) ||
          message.createdAt.isAfter(latestMessages[senderId]!.createdAt)) {
        latestMessages[senderId] = message;
      }
    }

    final conversationList = latestMessages.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      itemCount: conversationList.length,
      itemBuilder: (context, index) => MessageListTile(
        message: conversationList[index],
        messageContent: ref
            .read(adminMessagesProvider)
            .value!
            .lastWhere(
              (message) =>
                  message.senderId == conversationList[index].senderId ||
                  message.receiverId == conversationList[index].senderId,
            )
            .content,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminChatRoomPage(
              userId: conversationList[index].senderId,
              userName: conversationList[index].senderName,
            ),
          ),
        ),
      ),
    );
  }

  void _showBroadcastDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const BroadcastDialog(),
    );
  }
}
