import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:holom_said/core/utils/helper_methods/error.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../generated/l10n.dart';
import '../../../personalzation/providers/profile_providers.dart';
import '../../models/message_model.dart';
import '../../providers/messages_provider.dart';
import '../widgets/message_bubble.dart';

class UserChatPage extends ConsumerStatefulWidget {
  const UserChatPage({super.key});

  @override
  ConsumerState<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends ConsumerState<UserChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _markMessagesAsRead();
    });
  }

  void _markMessagesAsRead() {
    final userId = ref.read(userProfileProvider).value?.id;
    if (userId != null) {
      ref.read(messagesNotifierProvider.notifier).markAllAsRead(userId);
      ref.invalidate(unreadMessagesCountUserProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(userMessagesProvider);
    final currentUserId = ref.read(userProfileProvider).value?.id;

    ref.listen<AsyncValue<List<Message>>>(
      userMessagesProvider,
      (_, next) {
        next.whenData((_) => _scrollToBottom());
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).adminSuffix),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              data: (allMessages) {
                final chatMessages = allMessages
                    .where((m) =>
                        m.type ==
                            MessageType.broadcast || // Add broadcast messages
                        m.senderId == currentUserId ||
                        m.receiverId == currentUserId)
                    .toList();

                if (chatMessages.isEmpty) {
                  return Center(
                    child: Text(S.of(context).noMessages),
                  );
                }
                // Sort messages by timestamp
                chatMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(Sizes.defaultSpace),
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = chatMessages[index];
                    final isUser = message.senderId == currentUserId &&
                        message.type != MessageType.broadcast;
                    final isSequential = index < chatMessages.length - 1 &&
                        chatMessages[index + 1].senderId == message.senderId;

                    return MessageBubble(
                      message: message,
                      isUser: isUser,
                      isSequential: isSequential,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  Center(child: Text(S.of(context).errorLoadingData)),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: S.of(context).writeYourMessage,
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Iconsax.send_1, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final user = ref.read(userProfileProvider).value;

      final message = Message(
        senderId: user!.id,
        receiverId: null, // For all admins
        content: _messageController.text.trim(),
        subject: '', // No subject for chat messages
        type: MessageType.individual,
        senderName: '${user.firstname} ${user.lastname}',
        senderProfileUrl: user.profilePicture,
        isAdminSender: false,
      );

      await ref.read(messagesNotifierProvider.notifier).sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      ErrorUtils.showErrorSnackBar(S.of(context).messageSendError);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
