import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holom_said/core/constants/colors.dart';
import '../../models/message_model.dart';

class MessageBubble extends ConsumerStatefulWidget {
  final Message message;
  final bool isUser;
  final bool isSequential;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.isSequential = false,
  });

  @override
  ConsumerState<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble> {
  bool _showTime = false;

  @override
  Widget build(BuildContext context) {
    final time = _formatTime(widget.message.createdAt);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            widget.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment:
            widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _showTime = !_showTime),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
                minWidth: 0,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.isUser
                      ? Theme.of(context).primaryColor
                      : isDarkMode
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(
                        widget.isUser ? 16 : (widget.isSequential ? 16 : 0)),
                    bottomRight: Radius.circular(
                        widget.isUser ? (widget.isSequential ? 16 : 0) : 16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.message.subject.isNotEmpty)
                      Text(
                        '📌 ${widget.message.subject}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.isUser
                              ? AppColors.backgroundLight
                              : isDarkMode
                                  ? AppColors.backgroundLight
                                  : AppColors.backgroundDark,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      widget.message.content,
                      style: TextStyle(
                        color: widget.isUser
                            ? AppColors.backgroundLight
                            : isDarkMode
                                ? AppColors.backgroundLight
                                : AppColors.backgroundDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showTime)
            Padding(
              padding: EdgeInsets.only(
                top: 4,
                right: widget.isUser ? 0 : 12,
                left: widget.isUser ? 12 : 0,
              ),
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
