import 'package:generic_iot_sensor/model/sqfliteModel/sQL.dart';
import 'package:generic_iot_sensor/model/user_devicess/user_devies_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/tcpModel.dart';

class DBase {
  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'password.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE datum(id INTEGER PRIMARY KEY ,ip Text NOT NULL,Mac Text NOT NULL)",
        );
      },
    );
  }

  Future<int> insertPlanets(tcpModel passWord) async {
    int result = 0;
    final Database db = await initializedDB();
      result = await db.insert('planets', passWord.toJson(),
          );
    return result;
  }

  Future<List<tcpModel>> retriveModel() async{
    final Database db = await initializedDB();
    final List<Map<String,Object?>> queryResult = await db.query("planets");
    return queryResult.map((e) => tcpModel.fromMap(e)).toList();
  }
}