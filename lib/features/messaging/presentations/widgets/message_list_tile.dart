import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/colors.dart';
import '../../models/message_model.dart';

class MessageListTile extends StatelessWidget {
  final Message message;
  final VoidCallback onTap;
  final String messageContent;

  const MessageListTile({
    super.key,
    required this.message,
    required this.onTap,
    required this.messageContent,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = message.status == MessageStatus.sent;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: message.senderProfileUrl != null
              ? ClipOval(
                  child: Image.network(
                    message.senderProfileUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Iconsax.user, color: Colors.grey),
                  ),
                )
              : const Icon(Iconsax.user, color: Colors.grey),
        ),
        title: Text(
          message.senderName,
          style: TextStyle(
            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          messageContent,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isUnread ? AppColors.primaryLight : Colors.grey,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatDate(message.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: isUnread ? Colors.black87 : Colors.grey,
              ),
            ),
            if (isUnread)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Implement date formatting logic
    return '';
  }
}
