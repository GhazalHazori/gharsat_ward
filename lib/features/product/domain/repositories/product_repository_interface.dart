import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/product/enums/product_type.dart';
import 'package:gharsat_ward/interface/repo_interface.dart';

abstract class ProductRepositoryInterface<T> extends RepositoryInterface {
  Future<dynamic> getFilteredProductList(BuildContext context, String offset,
      ProductType productType, String? title, {int? shippingMethod});

  Future<dynamic> getBrandOrCategoryProductList(
      {required bool isBrand, required int id, required int offset, int? shippingMethod});

  Future<dynamic> getRelatedProductList(String id, {int? shippingMethod});

  Future<dynamic> getFeaturedProductList(String offset, {int? shippingMethod});

  Future<dynamic> getLatestProductList(String offset, {int? shippingMethod});

  Future<dynamic> getRecommendedProduct({int? shippingMethod});

  Future<dynamic> getMostDemandedProduct({int? shippingMethod});

  Future<dynamic> getFindWhatYouNeed({int? shippingMethod});

  Future<dynamic> getJustForYouProductList({int? shippingMethod});

  Future<dynamic> getMostSearchingProductList(int offset, {int? shippingMethod});

  Future<dynamic> getHomeCategoryProductList({int? shippingMethod});

  Future<dynamic> getClearanceAllProductList(String offset, {int? shippingMethod});

  Future<dynamic> getClearanceSearchProducts(
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
      {int? shippingMethod});
}
