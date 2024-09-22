import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../localDB/auth/getRestaurantPasswordHash.dart';

Future<int> createTable(String backendAddress, String tableName, String seats,
    String region) async {
  final response =
      await http.post(Uri.parse("$backendAddress/api/table/create"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'tableName': tableName,
            'seats': seats,
            'tableRegion': region,
            'password': await getRestaurantPasswordHash(backendAddress)
          }));
  return response.statusCode;
}

Future<List<dynamic>> getAllTables(String backendAddress) async {
  final response = await http.post(
      Uri.parse("$backendAddress/api/table/request/all"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          {'password': await getRestaurantPasswordHash(backendAddress)}));
  if (response.statusCode != 200) {
    throw Exception(
        "Failed to load tables! Please contact the support! Code: ${response.statusCode}");
  }
  return jsonDecode(response.body);
}

Future<void> deleteTable(String backendAddress, String tableName) async {
  final response =
      await http.post(Uri.parse("$backendAddress/api/table/delete"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'tableName': tableName,
            'password': await getRestaurantPasswordHash(backendAddress)
          }));
  if (response.statusCode != 200) {
    throw Exception(
        "Failed to load tables! Please contact the support! Code: ${response.statusCode}");
  }
}

Future<void> updateTableStatus(
    String backendAddress, String tableName, String newStatus) async {
  final response =
      await http.post(Uri.parse("$backendAddress/api/table/update/status"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'tableName': tableName,
            'password': await getRestaurantPasswordHash(backendAddress),
            'newStatus': newStatus
          }));
  if (response.statusCode != 200) {
    throw Exception(
        "Failed to load tables! Please contact the support! Code: ${response.statusCode}");
  }
}
