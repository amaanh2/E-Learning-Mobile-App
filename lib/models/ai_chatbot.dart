import 'package:http/http.dart' as http;
import 'dart:convert';


class Chatbot {
  static const _apiUrl = "https://api.openai.com/v1/chat/completions";
  static const _apiKey = "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";




  static Future<String> getResponse(String userInput) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": userInput}
        ],
        "temperature": 0.5,
        "max_tokens": 500,
      }),
    );


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception("Failed to load chatbot response: ${response.body}");
    }
  }
}
