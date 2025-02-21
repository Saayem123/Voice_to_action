import 'dart:convert';
import 'package:http/http.dart' as http;

class NLPService {
  final String apiKey = "your_openai_api_key"; // Replace with actual API key

  // Function to extract actions using OpenAI
  Future<Map<String, String>> extractActions(String text) async {
    var url = Uri.parse("https://api.openai.com/v1/chat/completions");

    try {
      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4",
          "messages": [
            {
              "role": "system",
              "content": "Extract actions, tasks, dates, and key points from the given text."
            },
            {
              "role": "user",
              "content": text
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        String extractedText = responseData['choices'][0]['message']['content'];

        print("🔹 Extracted Actions from OpenAI: $extractedText");

        return {
          "task": extractedText,
          "date": "Extracted via AI",
          "time": "Extracted via AI"
        };
      } else {
        print("❌ OpenAI API failed, falling back to Regex.");
        return extractActionsLocally(text);
      }
    } catch (e) {
      print("❌ Error calling OpenAI API: $e");
      return extractActionsLocally(text); // Fallback to regex-based extraction
    }
  }

  // Function to extract actions using Regex (Fallback)
  Map<String, String> extractActionsLocally(String transcribedText) {
    // Improved date regex (handles "12 Feb", "February 12", "Tomorrow")
    RegExp dateRegex = RegExp(
        r'\b(?:\d{1,2} (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))|(?:\b(?:Today|Tomorrow|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b)');

    // Improved time regex (handles "3 PM", "14:30", "12:45 AM")
    RegExp timeRegex = RegExp(r'\b(?:\d{1,2}:\d{2}|\d{1,2} (AM|PM))\b');

    // Extract date and time
    String date = dateRegex.firstMatch(transcribedText)?.group(0) ?? "No Date";
    String time = timeRegex.firstMatch(transcribedText)?.group(0) ?? "No Time";

    // Identify task/action based on keywords
    List<String> actionKeywords = [
      "schedule",
      "meeting",
      "reminder",
      "call",
      "email",
      "submit",
      "task",
      "deadline"
    ];
    String detectedTask = "No Task Found";
    for (String keyword in actionKeywords) {
      if (transcribedText.toLowerCase().contains(keyword)) {
        detectedTask = transcribedText; // Store full text as task
        break;
      }
    }

    // Construct extracted actions map
    Map<String, String> extractedActions = {
      "task": detectedTask,
      "date": date,
      "time": time
    };

    // Debugging: Print extracted actions
    print("🔹 Extracted Actions Locally: $extractedActions");

    return extractedActions;
  }
}
