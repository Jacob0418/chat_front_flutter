import 'package:flutter/material.dart';

class InputBar extends StatefulWidget {
  final Function(String) onSend;
  final bool isLoading;

  const InputBar({super.key, required this.onSend, this.isLoading = false});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;
    widget.onSend(_controller.text.trim());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !widget.isLoading,
              onSubmitted: (_) => _handleSend(),
              decoration: const InputDecoration(
                hintText: "Escribe tu pregunta...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            onPressed: widget.isLoading ? null : _handleSend,
          ),
        ],
      ),
    );
  }
}