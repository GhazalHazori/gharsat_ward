// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasource/remote/dio/dio_client.dart';
import '../../main.dart';
import '../../utill/app_constants.dart';
import '../address/controllers/address_controller.dart';
import '../auth/controllers/auth_controller.dart';
import '../auth/domain/models/city_model.dart';
import '../auth/domain/services/auth_service_interface.dart';
import '../banner/controllers/banner_controller.dart';
import '../brand/controllers/brand_controller.dart';
import '../cart/controllers/cart_controller.dart';
import '../category/controllers/category_controller.dart';
import '../deal/controllers/featured_deal_controller.dart';
import '../deal/controllers/flash_deal_controller.dart';
import '../notification/controllers/notification_controller.dart';
import '../product/controllers/product_controller.dart';
import '../profile/controllers/profile_contrroller.dart';
import '../shop/controllers/shop_controller.dart';
import '../splash/controllers/splash_controller.dart';

class CityController extends ChangeNotifier {
  final AuthServiceInterface authServiceInterface;
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  CityController({
    required this.authServiceInterface,
    required this.sharedPreferences,
    required this.dioClient,
  });

  bool _isLoadingCity = false;
  bool get isLoadingCity => _isLoadingCity;

  List<City> _cities = [];
  List<City> get cities => _cities;

  City? _selectedCity;
  City? get selectedCity => _selectedCity;

  Future<void> fetchCities() async {
    _isLoadingCity = true;
    notifyListeners();

    try {
      final apiResponse = await authServiceInterface.cities();

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _cities = (apiResponse.response!.data as List)
            .map((json) => City.fromJson(json))
            .toList();

        final savedCityId = sharedPreferences.getInt(AppConstants.choosenCity);
        _selectedCity = _cities.firstWhere(
          (city) => city.id == savedCityId,
          orElse: () => _cities.first,
        );
        await sharedPreferences.setInt(
            AppConstants.choosenCity, _selectedCity!.id);
      }
    } catch (e) {
      debugPrint('Error fetching cities: $e');
    } finally {
      _isLoadingCity = false;
      notifyListeners();
    }
  }

  Future<void> changeCity(City city) async {
    _selectedCity = city;
    await sharedPreferences.setInt(AppConstants.choosenCity, city.id);
    notifyListeners();
    // Here you can add logic to refresh other data that depends on city
    loadData(true);
  }

  static Future<void> loadData(bool reload) async {
    final flashDealController =
        Provider.of<FlashDealController>(Get.context!, listen: false);
    final shopController =
        Provider.of<ShopController>(Get.context!, listen: false);
    final categoryController =
        Provider.of<CategoryController>(Get.context!, listen: false);
    final bannerController =
        Provider.of<BannerController>(Get.context!, listen: false);
    final addressController =
        Provider.of<AddressController>(Get.context!, listen: false);
    final productController =
        Provider.of<ProductController>(Get.context!, listen: false);
    final brandController =
        Provider.of<BrandController>(Get.context!, listen: false);
    final featuredDealController =
        Provider.of<FeaturedDealController>(Get.context!, listen: false);
    final notificationController =
        Provider.of<NotificationController>(Get.context!, listen: false);
    final cartController =
        Provider.of<CartController>(Get.context!, listen: false);
    final profileController =
        Provider.of<ProfileController>(Get.context!, listen: false);
    final splashController =
        Provider.of<SplashController>(Get.context!, listen: false);

    if (flashDealController.flashDealList.isEmpty || reload) {
      await flashDealController.getFlashDealList(reload, true);
    }

    splashController.initConfig(Get.context!, null, null);

    categoryController.getCategoryList(reload);

    bannerController.getBannerList(reload);

    shopController.getTopSellerList(reload, 1, type: "top");

    shopController.getAllSellerList(reload, 1, type: "all");

    if (addressController.addressList == null ||
        (addressController.addressList != null &&
            addressController.addressList!.isEmpty) ||
        reload) {
      addressController.getAddressList();
    }

    cartController.getCartData(Get.context!);

    productController.getHomeCategoryProductList(reload);

    brandController.getBrandList(reload);

    featuredDealController.getFeaturedDealList(reload);

    productController.getLProductList('1', reload: reload);

    productController.getLatestProductList(1, reload: reload);

    productController.getFeaturedProductList('1', reload: reload);

    productController.getRecommendedProduct();

    productController.getClearanceAllProductList('1');

    if (notificationController.notificationModel == null ||
        (notificationController.notificationModel != null &&
            notificationController.notificationModel!.notification!.isEmpty) ||
        reload) {
      notificationController.getNotificationList(1);
    }

    if (Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn() &&
        profileController.userInfoModel == null) {
      profileController.getUserInfo(Get.context!);
    }
  }
}
