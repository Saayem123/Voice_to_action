import 'package:intl/intl.dart';

class ActionService {
  List<String> generateToDos(List<String> actions) {
    return actions.map((action) => "- $action").toList();
  }

  String createCalendarEvent(String meetingDetails) {
    return "Event scheduled: $meetingDetails";
  }

  String generateSummary(List<String> keyPoints) {
    return "Meeting Summary:\n" + keyPoints.join("\n");
  }
}
