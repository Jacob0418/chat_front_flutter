import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/chat/chat_controller.dart';
import 'features/chat/chat_screen.dart';

void main() {
  runApp(const ChatbotApp());
}

class ChatbotApp extends StatelessWidget {
  const ChatbotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatController(),
      child: Consumer<ChatController>(
        builder: (context, controller, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'RAG Assistant',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: controller.darkMode ? ThemeMode.dark : ThemeMode.light,
            home: const ChatScreen(),
          );
        },
      ),
    );
  }
}
