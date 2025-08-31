import 'package:flutter/material.dart';
import 'package:gharsat_ward/features/product/domain/repositories/product_repository_interface.dart';
import 'package:gharsat_ward/features/product/domain/services/product_service_interface.dart';
import 'package:gharsat_ward/features/product/enums/product_type.dart';

class ProductService implements ProductServiceInterface {
  ProductRepositoryInterface productRepositoryInterface;

  ProductService({required this.productRepositoryInterface});

  @override
  Future getBrandOrCategoryProductList(
      {required bool isBrand, required int id, required int offset, int? shippingMethod}) async {
    return await productRepositoryInterface.getBrandOrCategoryProductList(
        isBrand: isBrand, id: id, offset: offset, shippingMethod: shippingMethod);
  }

  @override
  Future getFeaturedProductList(String offset, {int? shippingMethod}) async {
    return await productRepositoryInterface.getFeaturedProductList(offset, shippingMethod: shippingMethod);
  }

  @override
  Future getFilteredProductList(BuildContext context, String offset,
      ProductType productType, String? title, {int? shippingMethod}) async {
    return await productRepositoryInterface.getFilteredProductList(
        context, offset, productType, title, shippingMethod: shippingMethod);
  }

  @override
  Future getFindWhatYouNeed({int? shippingMethod}) async {
    return await productRepositoryInterface.getFindWhatYouNeed(shippingMethod: shippingMethod);
  }

  @override
  Future getHomeCategoryProductList({int? shippingMethod}) async {
    return await productRepositoryInterface.getHomeCategoryProductList(shippingMethod: shippingMethod);
  }

  @override
  Future getJustForYouProductList({int? shippingMethod}) async {
    return await productRepositoryInterface.getJustForYouProductList(shippingMethod: shippingMethod);
  }

  @override
  Future getLatestProductList(String offset, {int? shippingMethod}) async {
    return await productRepositoryInterface.getLatestProductList(offset, shippingMethod: shippingMethod);
  }

  @override
  Future getMostDemandedProduct({int? shippingMethod}) async {
    return await productRepositoryInterface.getMostDemandedProduct(shippingMethod: shippingMethod);
  }

  @override
  Future getMostSearchingProductList(int offset, {int? shippingMethod}) async {
    return await productRepositoryInterface.getMostSearchingProductList(offset, shippingMethod: shippingMethod);
  }

  @override
  Future getRecommendedProduct({int? shippingMethod}) async {
    return await productRepositoryInterface.getRecommendedProduct(shippingMethod: shippingMethod);
  }

  @override
  Future getRelatedProductList(String id, {int? shippingMethod}) async {
    return await productRepositoryInterface.getRelatedProductList(id, shippingMethod: shippingMethod);
  }

  @override
  Future getClearanceAllProductList(String offset, {int? shippingMethod}) async {
    return await productRepositoryInterface.getClearanceAllProductList(offset, shippingMethod: shippingMethod);
  }

  @override
  Future getClearanceSearchProducts(
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
    return await productRepositoryInterface.getClearanceSearchProducts(
        query,
        categoryIds,
        brandIds,
        authorIds,
        publishingIds,
        sort,
        priceMin,
        priceMax,
        offset,
        productType,
        offerType,
        shippingMethod: shippingMethod);
  }
}
