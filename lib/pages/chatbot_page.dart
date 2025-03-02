import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key}); // Removed themeMode parameter

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  final String geminiApiKey = "AIzaSyA3A2OJWbkBuQYyKcVFUlngu8FkggIngQk";
  final String systemInstruction =
      "You are an Indian Agriculture expert. Provide concise, informative, and accurate responses related to Indian farming, crops, and agricultural practices.";

  void sendMessage() async {
    if (_controller.text.trim().isEmpty || isLoading) return;

    String userMessage = _controller.text.trim();
    setState(() {
      messages.add({"role": "user", "text": userMessage});
      isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      String responseText = await fetchGeminiResponse(userMessage);
      setState(() {
        messages.add({"role": "assistant", "text": responseText});
      });
    } catch (e) {
      setState(() {
        messages.add({"role": "assistant", "text": "Error fetching response."});
      });
    }

    setState(() => isLoading = false);
    _scrollToBottom();
  }

  Future<String> fetchGeminiResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey",
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "$systemInstruction\n\nUser: $prompt"},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      try {
        return data["candidates"][0]["content"]["parts"][0]["text"] ??
            "No response.";
      } catch (e) {
        return "Error parsing response.";
      }
    } else {
      return "Error: ${response.statusCode} - ${response.body}";
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark; // Detect theme here

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser = msg["role"] == "user";

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isUser
                                  ? Theme.of(context).primaryColor
                                  : isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft:
                                isUser ? Radius.circular(16) : Radius.zero,
                            bottomRight:
                                isUser ? Radius.zero : Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isDarkMode ? 0.2 : 0.12,
                              ),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: MarkdownBody(
                          data: msg["text"] ?? "",
                          selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              fontSize: 16,
                              color:
                                  isUser
                                      ? Colors.white
                                      : Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isLoading)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Ask about Indian Agriculture...",
                        filled: true,
                        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                        hintStyle: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
