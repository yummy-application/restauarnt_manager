import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../security/md5.dart';

Future<int> restaurantCreation(
    String address, String name, String image, String password) async {
  String passwordHash = generateMd5(password);
  try {
    final response = await http.post(
      Uri.parse('$address/api/restaurant/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'image': image,
        'password': passwordHash,
      }),
    );
    return response.statusCode;
  } catch (e) {
    print(e);
    return 400;
  }
}
