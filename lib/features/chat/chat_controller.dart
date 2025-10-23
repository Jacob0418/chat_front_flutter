import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models.dart';
import 'chat_repository.dart';

class ChatController extends ChangeNotifier {
  final ChatRepository _repo = ChatRepository();
  List<Message> messages = [];
  bool loading = false;
  String? error;
  bool darkMode = false;

  ChatController() {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('chat_history');
    if (saved != null) {
      messages = saved
          .map((e) => Message.fromJson(Map<String, dynamic>.from(jsonDecode(e))))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final list = messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('chat_history', list);
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty || loading) return;

    messages.add(Message(role: 'user', content: text));
    loading = true;
    notifyListeners();

    try {
      final answer = await _repo.ask(text, messages);
      messages.add(Message(role: 'assistant', content: answer));
      await _saveMessages();
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }

  // Bonus: streaming parcial de tokens
  Future<void> sendStreaming(String text) async {
    if (text.trim().isEmpty || loading) return;
    messages.add(Message(role: 'user', content: text));
    messages.add(Message(role: 'assistant', content: ""));
    loading = true;
    notifyListeners();

    final stream = _repo.askStream(text, messages);
    await for (final chunk in stream) {
      messages.last = Message(role: 'assistant', content: messages.last.content + chunk);
      notifyListeners();
    }

    loading = false;
    await _saveMessages();
    notifyListeners();
  }

  void toggleTheme() {
    darkMode = !darkMode;
    notifyListeners();
  }

  void clearHistory() {
    messages.clear();
    _saveMessages();
    notifyListeners();
  }
}
