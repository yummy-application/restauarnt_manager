import 'package:path/path.dart';
import 'package:restaurant_manager/localDB/setup/setup.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Map<String, Object?>>> getAllConnectedRestaurants() async {
  await dbSetup();
  var db = await openDatabase(
    join(await getDatabasesPath(), 'local.db'),
  );
  return await db.query("restaurants");
}
