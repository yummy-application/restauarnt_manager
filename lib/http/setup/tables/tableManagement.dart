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
