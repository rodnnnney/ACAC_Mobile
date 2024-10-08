import 'dart:convert';
import 'dart:io';

import 'package:ACAC/models/StartStop.dart';
import 'package:ACAC/models/Time.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

String apikey = dotenv.get("GOOGLE_MAPS_API_KEY");

Future<Map<String, dynamic>> getRestaurantDetails(String placeId) async {
  final String url =
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apikey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final result = data['result'];

    // Extract details and put them in a map
    Map<String, dynamic> restaurantDetails = {
      'name': result['name'],
      'rating': result['rating'],
      'number_of_reviews': result['user_ratings_total'],
      'website': result['website'] ?? 'No website available',
      'phone_number':
          result['formatted_phone_number'] ?? 'No phone number available',
      'opening_hours': result['opening_hours']?['weekday_text'] ??
          'No opening hours available',
      'address': result['formatted_address']
    };
    return restaurantDetails;
  } else {
    throw Exception('Failed to load restaurant details');
  }
}

Time convertWeekdayListToTime(List<dynamic> weekdayList) {
  // Convert List<dynamic> to List<String>
  List<String> weekdayStringList =
      weekdayList.map((item) => item.toString()).toList();

  Map<String, StartStop> schedule = {};

  for (String daySchedule in weekdayStringList) {
    List<String> parts = daySchedule.split(': ');
    if (parts.length != 2) {
      throw FormatException('Invalid format for day schedule: $daySchedule');
    }

    String dayName = parts[0].toLowerCase();
    String hours = parts[1];

    if (hours == 'Closed') {
      schedule[dayName] = StartStop(start: 'Closed', stop: 'Closed');
    } else {
      List<String> times = hours.split(' – ');
      if (times.length != 2) {
        throw FormatException('Invalid time format for $dayName: $hours');
      }
      schedule[dayName] = StartStop(start: times[0], stop: times[1]);
    }
  }

  return Time(
    monday: schedule['monday'] ?? StartStop(start: 'Closed', stop: 'Closed'),
    tuesday: schedule['tuesday'] ?? StartStop(start: 'Closed', stop: 'Closed'),
    wednesday:
        schedule['wednesday'] ?? StartStop(start: 'Closed', stop: 'Closed'),
    thursday:
        schedule['thursday'] ?? StartStop(start: 'Closed', stop: 'Closed'),
    friday: schedule['friday'] ?? StartStop(start: 'Closed', stop: 'Closed'),
    saturday:
        schedule['saturday'] ?? StartStop(start: 'Closed', stop: 'Closed'),
    sunday: schedule['sunday'] ?? StartStop(start: 'Closed', stop: 'Closed'),
  );
}

StartStop parseStartStop(String dayText) {
  final timeRange = dayText.split(": ")[1].trim(); // Extract the time range
  if (timeRange.toLowerCase() == "open 24 hours") {
    return StartStop(start: "Open 24 hours", stop: "Open 24 hours"); // Consider
    // 24-hour range
  }
  // For regular hours
  final times = timeRange.split(" – "); // Split using the dash
  return StartStop(
    start: times[0].trim(),
    stop: times[1].trim(),
  );
}

Time convertToTime(List<dynamic> weekdayText) {
  return Time(
    monday: parseStartStop(weekdayText[0]),
    tuesday: parseStartStop(weekdayText[1]),
    wednesday: parseStartStop(weekdayText[2]),
    thursday: parseStartStop(weekdayText[3]),
    friday: parseStartStop(weekdayText[4]),
    saturday: parseStartStop(weekdayText[5]),
    sunday: parseStartStop(weekdayText[6]),
  );
}

Future<File?> downloadAndSaveImage(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(imageUrl);
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);
      safePrint('Image successfully downloaded and saved: ${file.path}');
      return file;
    } else {
      safePrint('Failed to load image. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    safePrint('Error downloading image: $e');
    return null;
  }
}
