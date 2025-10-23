import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String role;    // 'user' o 'assistant'
  final String content;

  const MessageBubble({
    super.key,
    required this.role,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUser = role == 'user';
    final theme = Theme.of(context);
    final bgColor = isUser
        ? theme.colorScheme.primary.withOpacity(0.2)
        : theme.colorScheme.secondary.withOpacity(0.2);
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isUser ? 12 : 0),
      bottomRight: Radius.circular(isUser ? 0 : 12),
    );

    return Align(
      alignment: align,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
        ),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
