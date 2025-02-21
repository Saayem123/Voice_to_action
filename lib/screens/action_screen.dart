import 'package:flutter/material.dart';

class ActionScreen extends StatelessWidget {
  final Map<String, dynamic> extractedData;

  ActionScreen(this.extractedData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Extracted Actions")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tasks:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...extractedData["tasks"].map((task) => Text("- $task")),
            SizedBox(height: 10),
            Text("Meeting Details:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(extractedData["meeting_details"] ?? "No details found"),
            SizedBox(height: 10),
            Text("Key Points:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...extractedData["key_points"].map((point) => Text("- $point")),
          ],
        ),
      ),
    );
  }
}
