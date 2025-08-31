import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gharsat_ward/data/datasource/remote/dio/dio_client.dart';
import 'package:gharsat_ward/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gharsat_ward/data/model/api_response.dart';
import 'package:gharsat_ward/features/product/domain/repositories/product_repository_interface.dart';
import 'package:gharsat_ward/features/product/enums/product_type.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/utill/app_constants.dart';

class ProductRepository implements ProductRepositoryInterface {
  final DioClient? dioClient;
  ProductRepository({required this.dioClient});

  @override
  Future<ApiResponse> getFilteredProductList(BuildContext context,
      String offset, ProductType productType, String? title, {int? shippingMethod}) async {
    late String endUrl;

    if (productType == ProductType.bestSelling) {
      endUrl = AppConstants.bestSellingProductUri;
      title = getTranslated('best_selling', context);
    } else if (productType == ProductType.newArrival) {
      endUrl = AppConstants.newArrivalProductUri;
      title = getTranslated('new_arrival', context);
    } else if (productType == ProductType.topProduct) {
      endUrl = AppConstants.topProductUri;
      title = getTranslated('top_product', context);
    } else if (productType == ProductType.discountedProduct) {
      endUrl = AppConstants.discountedProductUri;
      title = getTranslated('discounted_product', context);
    }
    try {
      String finalUrl = endUrl + offset;
      if (shippingMethod != null) {
        finalUrl += '&shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(finalUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getBrandOrCategoryProductList(
      {required bool isBrand, required int id, required int offset, int? shippingMethod}) async {
    try {
      String uri;
      if (isBrand) {
        uri =
            '${AppConstants.brandProductUri}$id?guest_id=1&limit=10&offset=$offset';
      } else {
        uri =
            '${AppConstants.categoryProductUri}$id?guest_id=1&limit=10&offset=$offset';
      }
      if (shippingMethod != null) {
        uri += '&shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRelatedProductList(String id, {int? shippingMethod}) async {
    try {
      String uri = '${AppConstants.relatedProductUri}$id?guest_id=1';
      if (shippingMethod != null) {
        uri += '&shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getFeaturedProductList(String offset, {int? shippingMethod}) async {
    try {
      String uri = AppConstants.featuredProductUri + offset;
      if (shippingMethod != null) {
        uri += '&shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getLatestProductList(String offset, {int? shippingMethod}) async {
    try {
      String uri = AppConstants.latestProductUri + offset;
      if (shippingMethod != null) {
        uri += '&shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRecommendedProduct({int? shippingMethod}) async {
    try {
      String uri = AppConstants.dealOfTheDay;
      if (shippingMethod != null) {
        uri += '?shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getMostDemandedProduct({int? shippingMethod}) async {
    try {
      String uri = AppConstants.mostDemandedProduct;
      if (shippingMethod != null) {
        uri += '?shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getFindWhatYouNeed({int? shippingMethod}) async {
    try {
      String uri = AppConstants.findWhatYouNeed;
      if (shippingMethod != null) {
        uri += '?shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getJustForYouProductList({int? shippingMethod}) async {
    try {
      String uri = AppConstants.justForYou;
      if (shippingMethod != null) {
        uri += '?shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getMostSearchingProductList(int offset, {int? shippingMethod}) async {
    try {
      String uri = "${AppConstants.mostSearching}?guest_id=1&limit=10&offset=$offset";
      if (shippingMethod != null) {
        uri += '&shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getHomeCategoryProductList({int? shippingMethod}) async {
    try {
      String uri = AppConstants.homeCategoryProductUri;
      if (shippingMethod != null) {
        uri += '&shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getClearanceAllProductList(String offset, {int? shippingMethod}) async {
    try {
      String uri = AppConstants.clearanceAllProductUri + offset;
      if (shippingMethod != null) {
        uri += '&shipping_method=$shippingMethod';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getClearanceSearchProducts(
      String query,
      String? categoryIds,
      String? brandIds,
      String? authorIds,
      String? publishingIds,
      String? sort,
      String? priceMin,
      String? priceMax,
      int offset,
      String? productType,
      String? offerType,
      {int? shippingMethod}) async {
    try {
      log("===limit==>");
      Map<String, dynamic> data = {
        'search': base64.encode(utf8.encode(query)),
        'category': categoryIds != null ? categoryIds.toString() : '[]',
        'brand': brandIds ?? '[]',
        'product_authors': authorIds ?? '[]',
        'publishing_houses': publishingIds ?? '[]',
        'sort_by': sort,
        'price_min': priceMin,
        'price_max': priceMax,
        'limit': '20',
        'offset': offset,
        'guest_id': '1',
        'product_type': productType ?? 'all',
        'offer_type': offerType,
      };
      
      if (shippingMethod != null) {
        data['shipping_method'] = shippingMethod;
      }
      
      final response = await dioClient!.post(AppConstants.searchUri, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
