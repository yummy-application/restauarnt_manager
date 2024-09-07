import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../setup/setup.dart';

Future<String> getRestaurantPasswordHash(String backendUrl) async {
  await dbSetup();
  var db = await openDatabase(
    join(await getDatabasesPath(), 'local.db'),
  );
  var result = await db
      .query('restaurants', where: 'backend_url = ?', whereArgs: [backendUrl]);
  return result[0]["password_hash"].toString();
}
