import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, Object?>> getFullRestaurantInfo(
    String backendAddress) async {
  final response = await http
      .post(Uri.parse('$backendAddress/api/restaurant/info'), headers: {
    'Content-Type': 'application/json',
  });
  return jsonDecode(response.body);
}
