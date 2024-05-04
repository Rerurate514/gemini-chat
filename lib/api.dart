import 'package:google_generative_ai/google_generative_ai.dart';

const API_KEY = 'AIzaSyA-GqKmEUerGoviGE1m7D3z8RMYddN9pGA';

class APIController{
  final List<Content> _chatList = [];

  Future<String> send(String message) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: API_KEY);
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    return response.text ?? "null";
  }

  Future<String> chatStream(String message) async {
    final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: API_KEY,
        generationConfig: GenerationConfig(maxOutputTokens: 100));

    final chat = model.startChat(history: _chatList.isEmpty ? null : _chatList);
    var content = Content.text(message);
    var response = await chat.sendMessage(content);

    _chatList.add(Content.text(message));
    _chatList.add(Content.model([TextPart(response.text ?? "Error")]));
    return response.text ?? "";
  }
}