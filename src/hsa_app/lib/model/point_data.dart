import 'package:sqflite/sqflite.dart';
  
final String tablePowerAndWaterStage = 'PowerAndWaterStage';
final String columnId = '_id';
final String columnFreezeTime = 'freezeTime';
final String columnTerminalCount = 'terminalCount';
final String columnTkW = 'tkw';
final String columnWaterStage = 'waterStage';
final String columnTimeStamp = 'timeStamp';

class PowerWaterPoint {
  
  // 自增id
  int id;
  // 冻结时间
  String freezeTime;
  // 终端数量
  int terminalCount;
  // 有功
  double tkw;
  // 水位
  double waterStage;
  // 时间戳
  int timeStamp;

  PowerWaterPoint();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnFreezeTime: freezeTime ?? '',
      columnTerminalCount: terminalCount ?? 0,
      columnTkW: tkw ?? 0,
      columnWaterStage: waterStage ?? 0,
      columnTimeStamp: timeStamp ?? DateTime.now(),
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  PowerWaterPoint.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    freezeTime = map[columnFreezeTime] ?? '';
    terminalCount = map[columnTerminalCount] ?? 0;
    tkw = map[columnTkW] ?? 0;
    waterStage = map[columnWaterStage] ?? 0;
    timeStamp = map[columnTimeStamp] ?? DateTime.now();
  }
}

class PowerWaterPointProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tablePowerAndWaterStage ( 
  $columnId integer primary key autoincrement, 
  $columnFreezeTime text not null,
  $columnTerminalCount integer not null,
  $columnTkW real not null,
  $columnWaterStage real not null,
  $columnTimeStamp integer not null
  )
  ''');
    });
  }

  Future<PowerWaterPoint> insert(PowerWaterPoint point) async {
    point.id = await db.insert(tablePowerAndWaterStage, point.toMap());
    return point;
  }

  Future<List<PowerWaterPoint>> getAllPowerWaterPoints (int limit) async {
    List<Map> maps = await db.query(tablePowerAndWaterStage,
      columns: [
      columnId, 
      columnFreezeTime, 
      columnTerminalCount,
      columnTkW, 
      columnWaterStage,
      columnTimeStamp,
      ],
      limit: limit,
      whereArgs: null,
    );
    if (maps.length > 0) {
      List<PowerWaterPoint> list = [];
      for (final map in maps) {
        list.add(PowerWaterPoint.fromMap(map));
      }
      return list;
    }
    return null;
  }

  Future<PowerWaterPoint> getPowerWaterPoint(int id) async {
    List<Map> maps = await db.query(tablePowerAndWaterStage,
        columns: [
        columnId, 
        columnFreezeTime, 
        columnTerminalCount,
        columnTkW, 
        columnWaterStage,
        columnTimeStamp
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return PowerWaterPoint.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tablePowerAndWaterStage, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(PowerWaterPoint point) async {
    return await db.update(tablePowerAndWaterStage, point.toMap(),
        where: '$columnId = ?', whereArgs: [point.id]);
  }

  Future close() async => db.close();
}