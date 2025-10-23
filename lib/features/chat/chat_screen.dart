import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './widgets/message_bubble.dart';
import './widgets/input_bar.dart';
import './widgets/typing_indicator.dart';
import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot RAG"),
        actions: [
          IconButton(
            icon: Icon(controller.darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: controller.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: controller.clearHistory,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return MessageBubble(role: msg.role, content: msg.content);
                },
              ),
            ),
            if (controller.loading) const TypingIndicator(),
            InputBar(onSend: controller.sendStreaming),
          ],
        ),
      ),
      backgroundColor:
          controller.darkMode ? Colors.grey[900] : Colors.grey[100],
    );
  }
}
