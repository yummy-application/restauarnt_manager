import 'package:http/http.dart' as http;

Future<bool> validateBackendAddress(String backendAddress) async {
  backendAddress = "$backendAddress/test";
  try {
    final response = await http.get(Uri.parse(backendAddress));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
