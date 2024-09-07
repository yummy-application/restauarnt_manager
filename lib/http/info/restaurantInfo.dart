import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../localDB/auth/getRestaurantPasswordHash.dart';

Future<Map<String, Object?>> getFullRestaurantInfo(
    String backendAddress) async {
  final response = await http
      .post(Uri.parse('$backendAddress/api/restaurant/info'), headers: {
    'Content-Type': 'application/json',
    'passwordHash': await getRestaurantPasswordHash(backendAddress)
  });
  return jsonDecode(response.body);
}
