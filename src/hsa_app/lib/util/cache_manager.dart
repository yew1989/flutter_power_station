import 'package:path/path.dart' as path;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

//缓存配置文件
class LEADCacheManager extends BaseCacheManager {
  static const key = "LEADCache";

  static LEADCacheManager _instance;

  factory LEADCacheManager() {
    if (_instance == null) {
      _instance = new LEADCacheManager._();
    }
    return _instance;
  }

  LEADCacheManager._() : super(key,
      maxAgeCacheObject: Duration(days: 7),
      maxNrOfCacheObjects: 50,
      );

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, key);
  }

}
