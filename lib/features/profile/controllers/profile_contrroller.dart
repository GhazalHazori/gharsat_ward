import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/data/model/api_response.dart';
import 'package:gharsat_ward/data/model/response_model.dart';
import 'package:gharsat_ward/features/profile/domain/models/profile_model.dart';
import 'package:gharsat_ward/features/profile/domain/services/profile_service_interface.dart';
import 'package:gharsat_ward/helper/api_checker.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:http/http.dart' as http;

import '../../auth/domain/models/city_model.dart';
import '../../auth/domain/services/auth_service_interface.dart';

class ProfileController extends ChangeNotifier {
  final ProfileServiceInterface? profileServiceInterface;
  final AuthServiceInterface authServiceInterface;
  ProfileController(
      {required this.profileServiceInterface,
      required this.authServiceInterface});

  // mr_edit
  bool _isLoadingCity = false;
  bool get isLoadingCity => _isLoadingCity;
  List<City> _cities = [];
  List<City> get cities => _cities;
  Future fetchCities() async {
    _isLoadingCity = true;
    notifyListeners();
    final apiResponse = await authServiceInterface.cities();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _cities = (apiResponse.response.data as List)
          .map((json) => City.fromJson(json))
          .toList();
      notifyListeners();
    } else {
      debugPrint('Error fetching cities: ${apiResponse.error}');
    }
    _isLoadingCity = false;
    notifyListeners();
  }

  ProfileModel? _userInfoModel;
  bool _isLoading = false;
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  double? _balance;
  double? get balance => _balance;
  ProfileModel? get userInfoModel => _userInfoModel;
  bool get isLoading => _isLoading;
  double? loyaltyPoint = 0;
  String userID = '-1';

  Future<String> getUserInfo(BuildContext context) async {
    ApiResponse apiResponse = await profileServiceInterface!.getProfileInfo();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      debugPrint('apiResponse.response!.data: ${apiResponse.response!.data}');
      _userInfoModel = ProfileModel.fromJson(apiResponse.response!.data);
      userID = _userInfoModel!.id.toString();
      _balance = _userInfoModel?.walletBalance ?? 0;
      loyaltyPoint = _userInfoModel?.loyaltyPoint ?? 0;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return userID;
  }

  Future<ApiResponse> deleteCustomerAccount(
      BuildContext context, int customerId) async {
    _isDeleting = true;
    notifyListeners();
    ApiResponse apiResponse = await profileServiceInterface!.delete(customerId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isDeleting = false;
      Map map = apiResponse.response!.data;
      String message = map['message'];
      showCustomSnackBar(message, Get.context!, isError: false);
    } else {
      _isDeleting = false;

      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ResponseModel> updateUserInfo(ProfileModel updateUserModel,
      String pass, File? file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response = await profileServiceInterface!
        .updateProfile(updateUserModel, pass, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      debugPrint(response.toString());
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
      Navigator.of(Get.context!).pop();
    } else {
      final String responseBody = await response.stream.bytesToString();
      debugPrint(responseBody);
      var decodedData = jsonDecode(responseBody);

      String? errorMessage;

      if (decodedData != null) {
        errorMessage = decodedData['errors']?[0]?['message'];
      }
      responseModel =
          ResponseModel('${errorMessage ?? response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }

  void clearProfileData() {
    _userInfoModel = null;
    notifyListeners();
  }
}
