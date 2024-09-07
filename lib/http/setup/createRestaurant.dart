import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> restaurantCreation(
    String address, String name, String image, String password) async {
  final response = await http.post(
      Uri.parse('$address/api/restaurant/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'name': name,
        'image': image,
        'password': password,
      });
}
