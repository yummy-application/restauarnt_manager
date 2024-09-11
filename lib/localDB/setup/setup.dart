import 'package:restauarnt_manager/security/md5.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> dbSetup() async {
  var db = await openDatabase(join(await getDatabasesPath(), 'local.db'),
      version: 7, onCreate: (db, version) {
    db.execute(
      "CREATE TABLE IF NOT EXISTS restaurants(backend_url Text,password_hash Text)",
    );
  }, onUpgrade: (db, oldVersion, newVersion) {
    db.execute("DROP TABLE IF EXISTS restaurants");
    db.execute(
      "CREATE TABLE IF NOT EXISTS restaurants(backend_url Text,password_hash Text)",
    );
  });
}

Future<void> addRestaurantConnection(String backendUrl, String password) async {
  await dbSetup();
  String passwordHash = generateMd5(password);
  var db = await openDatabase(
    join(await getDatabasesPath(), 'local.db'),
  );
  db.rawInsert(
      'INSERT INTO restaurants(backend_url,password_hash) VALUES("$backendUrl","$passwordHash")');
}
