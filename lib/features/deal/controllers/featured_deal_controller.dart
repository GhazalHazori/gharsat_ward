import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/data/local/cache_response.dart';
import 'package:gharsat_ward/data/model/api_response.dart';
import 'package:gharsat_ward/features/deal/domain/services/featured_deal_service_interface.dart';
import 'package:gharsat_ward/features/product/domain/models/product_model.dart';

import 'package:gharsat_ward/helper/api_checker.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/utill/app_constants.dart';

class FeaturedDealController extends ChangeNotifier {
  final FeaturedDealServiceInterface featuredDealServiceInterface;
  FeaturedDealController({required this.featuredDealServiceInterface});

  int? _featuredDealSelectedIndex;
  List<Product>? _featuredDealProductList;
  List<Product>? get featuredDealProductList => _featuredDealProductList;
  int? get featuredDealSelectedIndex => _featuredDealSelectedIndex;
  
  // Shipping method: 1 for express, 2 for pre-order
  int _shippingMethod = 1; // Default to express
  int get shippingMethod => _shippingMethod;

  Future<void> getFeaturedDealList(bool reload) async {
    var localData =
        await database.getCacheResponseById(AppConstants.featuredDealUri);

    if (localData != null) {
      _featuredDealProductList = [];
      var featuredDealProductList = jsonDecode(localData.response);
      featuredDealProductList.forEach((featuredDealProduct) =>
          _featuredDealProductList?.add(Product.fromJson(featuredDealProduct)));
      notifyListeners();
    }

    _featuredDealProductList = [];
    ApiResponse apiResponse =
        await featuredDealServiceInterface.getFeaturedDeal(shippingMethod: _shippingMethod);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200 &&
        apiResponse.response!.data.toString() != '{}') {
      _featuredDealProductList = [];
      apiResponse.response!.data.forEach(
          (fDeal) => _featuredDealProductList?.add(Product.fromJson(fDeal)));
      _featuredDealSelectedIndex = 0;

      if (localData != null) {
        await database.updateCacheResponse(
            AppConstants.featuredDealUri,
            CacheResponseCompanion(
              endPoint: const Value(AppConstants.featuredDealUri),
              header: Value(jsonEncode(apiResponse.response!.headers.map)),
              response: Value(jsonEncode(apiResponse.response!.data)),
            ));
      } else {
        await database.insertCacheResponse(
          CacheResponseCompanion(
            endPoint: const Value(AppConstants.featuredDealUri),
            header: Value(jsonEncode(apiResponse.response!.headers.map)),
            response: Value(jsonEncode(apiResponse.response!.data)),
          ),
        );
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void changeSelectedIndex(int selectedIndex) {
    _featuredDealSelectedIndex = selectedIndex;
    notifyListeners();
  }

  void changeShippingMethod(int method) {
    _shippingMethod = method;
    // Reload featured deals with new shipping method
    getFeaturedDealList(true);
    notifyListeners();
  }
}
