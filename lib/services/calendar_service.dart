import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

class CalendarService {
  final _credentials = ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": "your_project_id",
    "private_key_id": "your_private_key_id",
    "private_key": "your_private_key",
    "client_email": "your_service_account_email",
    "client_id": "your_client_id",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token"
  });

  Future<void> addEvent(String summary, String dateTime) async {
    final client = await clientViaServiceAccount(_credentials, [CalendarApi.calendarScope]);
    var calendar = CalendarApi(client);

    var event = Event()
      ..summary = summary
      ..start = (EventDateTime()..dateTime = DateTime.parse(dateTime))
      ..end = (EventDateTime()..dateTime = DateTime.parse(dateTime).add(Duration(hours: 1)));

    await calendar.events.insert(event, "primary");
  }
}
