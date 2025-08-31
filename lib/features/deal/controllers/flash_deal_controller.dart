import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/data/local/cache_response.dart';
import 'package:gharsat_ward/data/model/api_response.dart';
import 'package:gharsat_ward/features/deal/domain/models/flash_deal_model.dart';
import 'package:gharsat_ward/features/deal/domain/services/flash_deal_service_interface.dart';
import 'package:gharsat_ward/features/product/domain/models/product_model.dart';
import 'package:gharsat_ward/helper/api_checker.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/utill/app_constants.dart';
import 'package:intl/intl.dart';

class FlashDealController extends ChangeNotifier {
  final FlashDealServiceInterface flashDealServiceInterface;
  FlashDealController({required this.flashDealServiceInterface});

  FlashDealModel? _flashDeal;
  final List<Product> _flashDealList = [];
  Duration? _duration;
  Timer? _timer;
  FlashDealModel? get flashDeal => _flashDeal;
  List<Product> get flashDealList => _flashDealList;
  Duration? get duration => _duration;
  int? _currentIndex;
  int? get currentIndex => _currentIndex;
  
  // Shipping method: 1 for express, 2 for pre-order
  int _shippingMethod = 1; // Default to express
  int get shippingMethod => _shippingMethod;

  Future<void> getFlashDealList(bool reload, bool notify) async {
    var localData =
        await database.getCacheResponseById(AppConstants.flashDealUri);
    CacheResponseData? localData2;

    if (localData != null) {
      _flashDeal = FlashDealModel.fromJson(jsonDecode(localData.response));
      print('FlashDeal loaded from cache: ${_flashDeal?.id}');

      if (_flashDeal!.id != null) {
        DateTime endTime = DateFormat("yyyy-MM-dd")
            .parse(_flashDeal!.endDate!)
            .add(const Duration(days: 2));
        _duration = endTime.difference(DateTime.now());
        _timer?.cancel();
        _timer = null;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _duration = _duration! - const Duration(seconds: 1);
          notifyListeners();
        });

        localData2 = await database
            .getCacheResponseById(AppConstants.flashDealProductUri);

        if (localData2 != null) {
          _flashDealList.clear();
          var products = jsonDecode(localData2.response);

          products.forEach(
              (flashDeal) => _flashDealList.add(Product.fromJson(flashDeal)));
          _currentIndex = 0;
        }
      }
      notifyListeners();
    }

    if (_flashDealList.isEmpty || reload) {
      ApiResponse apiResponse = await flashDealServiceInterface.getFlashDeal(shippingMethod: _shippingMethod);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _flashDeal = FlashDealModel.fromJson(apiResponse.response!.data);

        print('FlashDeal response: $_flashDeal');
        print('FlashDeal ID: ${_flashDeal?.id}');
        print('FlashDeal endDate: ${_flashDeal?.endDate}');

        if (localData != null) {
          await database.updateCacheResponse(
              AppConstants.flashDealUri,
              CacheResponseCompanion(
                endPoint: const Value(AppConstants.flashDealUri),
                header: Value(jsonEncode(apiResponse.response!.headers.map)),
                response: Value(jsonEncode(apiResponse.response!.data)),
              ));
        } else {
          await database.insertCacheResponse(
            CacheResponseCompanion(
              endPoint: const Value(AppConstants.flashDealUri),
              header: Value(jsonEncode(apiResponse.response!.headers.map)),
              response: Value(jsonEncode(apiResponse.response!.data)),
            ),
          );
        }

        if (_flashDeal!.id != null) {
          DateTime endTime = DateFormat("yyyy-MM-dd")
              .parse(_flashDeal!.endDate!)
              .add(const Duration(days: 2));
          _duration = endTime.difference(DateTime.now());
          _timer?.cancel();
          _timer = null;
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            _duration = _duration! - const Duration(seconds: 1);
            notifyListeners();
          });

          ApiResponse megaDealResponse =
              await flashDealServiceInterface.get(_flashDeal!.id.toString(), shippingMethod: _shippingMethod);

          if (megaDealResponse.response != null &&
              megaDealResponse.response!.statusCode == 200) {
            _flashDealList.clear();
            megaDealResponse.response!.data.forEach(
                (flashDeal) => _flashDealList.add(Product.fromJson(flashDeal)));
            _currentIndex = 0;
            print('FlashDeal products loaded: ${_flashDealList.length}');

            if (localData2 != null) {
              await database.updateCacheResponse(
                  AppConstants.flashDealProductUri,
                  CacheResponseCompanion(
                    endPoint: const Value(AppConstants.flashDealProductUri),
                    header: Value(
                        jsonEncode(megaDealResponse.response!.headers.map)),
                    response:
                        Value(jsonEncode(megaDealResponse.response!.data)),
                  ));
            } else {
              await database.insertCacheResponse(
                CacheResponseCompanion(
                  endPoint: const Value(AppConstants.flashDealProductUri),
                  header:
                      Value(jsonEncode(megaDealResponse.response!.headers.map)),
                  response: Value(jsonEncode(megaDealResponse.response!.data)),
                ),
              );
            }
            notifyListeners();
          } else {
            ApiChecker.checkApi(megaDealResponse);
          }
        } else {
          notifyListeners();
        }
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void changeShippingMethod(int method) {
    _shippingMethod = method;
    // Reload flash deals with new shipping method
    getFlashDealList(true, true);
    notifyListeners();
  }
}
