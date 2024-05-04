import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:vercel_test/api.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _gemini = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3af');

  final APIController _apiController = APIController();

  String _textBuffer = "";

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Chat(
      user: _user,
      messages: _messages,
      onSendPressed: _handleSendPressed,
    ),
  );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _sendToGemini(message);
    _addMessage(textMessage);
  }

  void _sendToGemini(types.PartialText message) async {
    final String response = await _apiController.chatStream(message.text);
    final textMessage = types.TextMessage(
      author: _gemini,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: response,
    );

    _addMessage(textMessage);
  }
}
