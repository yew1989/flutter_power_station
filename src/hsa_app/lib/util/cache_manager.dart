import 'package:path/path.dart' as p;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

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
      fileFetcher: _customHttpGetter
      
      );

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }

  static Future<FileFetcherResponse> _customHttpGetter(String url, {Map<String, String> headers}) async {
    // Do things with headers, the url or whatever.
    return HttpFileFetcherResponse(await http.get(url, headers: headers));
  }
}
