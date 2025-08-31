import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gharsat_ward/data/local/cache_response.dart';
import 'package:gharsat_ward/data/model/api_response.dart';
import 'package:gharsat_ward/main.dart';

class CacheManager {
  static Future<CacheResponseData?> getLocalData(String endpoint) async {
    return await database.getCacheResponseById(endpoint);
  }

  static Future<void> storeBrandListInCache(
    bool hasLocalData,
    String endpoint,
    ApiResponse apiResponse,
  ) async {
    final cacheData = CacheResponseCompanion(
      endPoint: Value(endpoint),
      header: Value(jsonEncode(apiResponse.response!.headers.map)),
      response: Value(jsonEncode(apiResponse.response!.data)),
    );

    // if(hasLocalData) {
    //  debugPrint("=update lcoal data=");
    //   await database.updateCacheResponse(endpoint, cacheData);
    // } else {
    await database.insertCacheResponse(cacheData);
    // }
  }
}
