import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/utils/helper_methods/error.dart';
import '../../../../generated/l10n.dart';
import '../../../personalzation/providers/profile_providers.dart';
import '../../models/message_model.dart';
import '../../providers/messages_provider.dart';
import '../widgets/message_bubble.dart';

class AdminChatRoomPage extends ConsumerStatefulWidget {
  final String userId;
  final String userName;

  const AdminChatRoomPage({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  ConsumerState<AdminChatRoomPage> createState() => _AdminChatRoomPageState();
}

class _AdminChatRoomPageState extends ConsumerState<AdminChatRoomPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _markMessagesAsRead();
    });
  }

  void _markMessagesAsRead() async {
    final messages = ref.read(adminMessagesProvider).value ?? [];
    final unreadMessages = messages.where((m) =>
            m.senderId == widget.userId &&
            m.status == MessageStatus.sent &&
            !m.isAdminSender // Only mark messages from user as read
        );

    for (var message in unreadMessages) {
      if (message.id != null) {
        await ref
            .read(messagesNotifierProvider.notifier)
            .markAsRead(message.id!);
      }
    }
    // Force refresh providers
    ref.invalidate(unreadMessagesCountAdminProvider);
    ref.invalidate(adminMessagesProvider);
    ref.invalidate(userMessagesProvider);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(adminMessagesProvider);

    ref.listen<AsyncValue<List<Message>>>(
      adminMessagesProvider,
      (_, next) {
        next.whenData((_) => _scrollToBottom());
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.when(
              data: (allMessages) {
                final chatMessages = allMessages
                    .where((m) =>
                        m.senderId == widget.userId ||
                        m.receiverId == widget.userId ||
                        m.type == MessageType.broadcast) // Add this condition
                    .toList();

                if (chatMessages.isEmpty) {
                  return Center(
                    child: Text(S.of(context).noMessages),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(Sizes.defaultSpace),
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    final currentUserId =
                        ref.read(adminProfileProvider).value!.id;
                    // Check if the message is from the current user
                    final message = chatMessages[index];
                    final isUser = message.senderId == currentUserId;

                    // Check if next message exists and is from the same sender
                    final isSequential = index < chatMessages.length - 1 &&
                        chatMessages[index + 1].senderId == message.senderId;
                    return MessageBubble(
                        message: message,
                        isUser: isUser,
                        isSequential: isSequential);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: Text(S.of(context).errorLoadingData),
              ),
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
      final admin = ref.read(adminProfileProvider).value;

      final message = Message(
        senderId: admin!.id,
        receiverId: widget.userId,
        content: _messageController.text.trim(),
        subject: '', // No subject for chat messages
        type: MessageType.individual,
        senderName: '${admin.firstname} ${S.of(context).adminSuffix}',
        senderProfileUrl: admin.profilePicture,
        isAdminSender: true,
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
}
