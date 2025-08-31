import 'dart:convert';

import 'package:gharsat_ward/data/model/api_response.dart';
import 'package:gharsat_ward/features/auth/controllers/auth_controller.dart';
import 'package:gharsat_ward/features/checkout/domain/services/checkout_service_interface.dart';
import 'package:gharsat_ward/features/invoice/controllers/invoice_controller.dart';
import 'package:gharsat_ward/features/invoice/domins/models/pre_invoice.dart';
import 'package:gharsat_ward/features/offline_payment/domain/models/offline_payment_model.dart';
import 'package:gharsat_ward/features/splash/controllers/splash_controller.dart';
import 'package:gharsat_ward/helper/api_checker.dart';
import 'package:gharsat_ward/localization/language_constrants.dart';
import 'package:gharsat_ward/main.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:gharsat_ward/features/checkout/screens/digital_payment_order_place_screen.dart';
import 'package:gharsat_ward/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CheckoutController with ChangeNotifier {
  final CheckoutServiceInterface checkoutServiceInterface;
  CheckoutController({required this.checkoutServiceInterface});

  int? _addressIndex;
  int? _billingAddressIndex;
  int? get billingAddressIndex => _billingAddressIndex;
  int? _shippingIndex;
  bool _isLoading = false;
  bool _isCheckCreateAccount = false;
  bool _newUser = false;

  int _paymentMethodIndex = -1;
  bool _onlyDigital = true;
  bool get onlyDigital => _onlyDigital;
  int? get addressIndex => _addressIndex;
  int? get shippingIndex => _shippingIndex;
  bool get isLoading => _isLoading;
  int get paymentMethodIndex => _paymentMethodIndex;
  bool get isCheckCreateAccount => _isCheckCreateAccount;

  bool _changeAmountShow = false;
  bool get changeAmountShow => _changeAmountShow;

  double? _cashChangesAmount;
  double? get cashChangesAmount => _cashChangesAmount;

  String selectedPaymentName = '';
  void setSelectedPayment(String payment) {
    selectedPaymentName = payment;
    notifyListeners();
  }
  PreInvoice? _preInvoice;
 
  String? _error;

  PreInvoice? get preInvoice => _preInvoice;
 
  String? get error => _error;

  Future<void> generatePreInvoice() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final guestId = Provider.of<AuthController>(Get.context!, listen: false)
          .getGuestIdUrl();

      final token = Provider.of<AuthController>(Get.context!, listen: false)
          .getUserToken();

      final response = await http.post(
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.genertInvoiceId}?guest_id=$guestId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['id'] != null && data['id'].toString().isNotEmpty) {
          _preInvoice = PreInvoice.fromJson(data);
        } else {
          _error = 'Invoice ID missing from response';
        }
      } else {
        _error =
            'Failed to generate invoice: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      _error = 'Error communicating with server: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }
  Future<String?> getInvoiceId() async {
  await generatePreInvoice();
  return _preInvoice?.id; // تأكد أن `PreInvoice` لديه حقل `id`
}

  final TextEditingController orderNoteController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  List<String> inputValueList = [];

  Future<void> placeOrder(
      {required Function callback,
      String? addressID,
      String? couponCode,
      String? couponAmount,
      String? billingAddressId,
      String? orderNote,
      String? transactionId,
      String? paymentNote,
      int? id,
      String? name,
      bool isfOffline = false,
      bool wallet = false}) async {
    for (TextEditingController textEditingController
        in inputFieldControllerList) {
      inputValueList.add(textEditingController.text.trim());
    }
 final invoiceId =await getInvoiceId() ;
    _isLoading = true;
    _newUser = false;
    notifyListeners();
    ApiResponse apiResponse;
    isfOffline
        ? apiResponse = await checkoutServiceInterface.offlinePaymentPlaceOrder(
            addressID,
            couponCode,
            couponAmount,
            billingAddressId,
            orderNote,
            keyList,
            inputValueList,
            offlineMethodSelectedId,
            offlineMethodSelectedName,
            paymentNote,
            _isCheckCreateAccount,
            passwordController.text.trim())
        : wallet
            ? apiResponse =
                await checkoutServiceInterface.walletPaymentPlaceOrder(
                    addressID,
                    couponCode,
                    couponAmount,
                    billingAddressId,
                    orderNote,
                    _isCheckCreateAccount,
                    passwordController.text.trim())
            : apiResponse =
                await checkoutServiceInterface.cashOnDeliveryPlaceOrder(
                addressID: addressID,
                couponCode: couponCode,
                couponDiscountAmount: couponAmount,
                billingAddressId: billingAddressId,
                orderNote: orderNote,
                isCheckCreateAccount: _isCheckCreateAccount,
                password: passwordController.text.trim(),
                cashChangeAmount: _cashChangesAmount,
                invoiceId:invoiceId ,
                currentCurrencyCode:
                    Provider.of<SplashController>(Get.context!, listen: false)
                        .myCurrency
                        ?.code,
              );

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isCheckCreateAccount = false;
      _isLoading = false;
      _addressIndex = null;
      _billingAddressIndex = null;
      sameAsBilling = false;
      if (!Provider.of<AuthController>(Get.context!, listen: false)
          .isLoggedIn()) {
        _newUser = apiResponse.response!.data['new_user'];
      }

      String message = apiResponse.response!.data.toString();
      callback(true, message, '', _newUser);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }

  void setBillingAddressIndex(int index) {
    _billingAddressIndex = index;
    notifyListeners();
  }

  void resetPaymentMethod() {
    _paymentMethodIndex = -1;
    isCODChecked = false;
    isWalletChecked = false;
    isOfflineChecked = false;
  }

  void shippingAddressNull() {
    _addressIndex = null;
    notifyListeners();
  }

  void billingAddressNull() {
    _billingAddressIndex = null;
    notifyListeners();
  }

  void setSelectedShippingAddress(int index) {
    _shippingIndex = index;
    notifyListeners();
  }

  void setSelectedBillingAddress(int index) {
    _billingAddressIndex = index;
    notifyListeners();
  }

  bool isOfflineChecked = false;
  bool isCODChecked = false;
  bool isWalletChecked = false;

  void setOfflineChecked(String type) {
    if (type == 'offline') {
      isOfflineChecked = !isOfflineChecked;
      isCODChecked = false;
      isWalletChecked = false;
      _paymentMethodIndex = -1;
      setOfflinePaymentMethodSelectedIndex(0);
    } else if (type == 'cod') {
      isCODChecked = !isCODChecked;
      isOfflineChecked = false;
      isWalletChecked = false;
      _paymentMethodIndex = -1;
    } else if (type == 'wallet') {
      isWalletChecked = !isWalletChecked;
      isOfflineChecked = false;
      isCODChecked = false;
      _paymentMethodIndex = -1;
    }

    notifyListeners();
  }

  String selectedDigitalPaymentMethodName = '';

  void setDigitalPaymentMethodName(int index, String name) {
    _paymentMethodIndex = index;
    selectedDigitalPaymentMethodName = name;
    isCODChecked = false;
    isWalletChecked = false;
    isOfflineChecked = false;
    notifyListeners();
  }

  void digitalOnly(bool value, {bool isUpdate = false}) {
    _onlyDigital = value;
    if (isUpdate) {
      notifyListeners();
    }
  }

  OfflinePaymentModel? offlinePaymentModel;
  Future<ApiResponse> getOfflinePaymentList() async {
    ApiResponse apiResponse =
        await checkoutServiceInterface.offlinePaymentList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      offlineMethodSelectedIndex = 0;
      offlinePaymentModel =
          OfflinePaymentModel.fromJson(apiResponse.response?.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  List<TextEditingController> inputFieldControllerList = [];
  List<String?> keyList = [];
  int offlineMethodSelectedIndex = -1;
  int offlineMethodSelectedId = 0;
  String offlineMethodSelectedName = '';

  void setOfflinePaymentMethodSelectedIndex(int index, {bool notify = true}) {
    keyList = [];
    inputFieldControllerList = [];
    offlineMethodSelectedIndex = index;
    if (offlinePaymentModel != null &&
        offlinePaymentModel!.offlineMethods != null &&
        offlinePaymentModel!.offlineMethods!.isNotEmpty) {
      offlineMethodSelectedId =
          offlinePaymentModel!.offlineMethods![offlineMethodSelectedIndex].id!;
      offlineMethodSelectedName = offlinePaymentModel!
          .offlineMethods![offlineMethodSelectedIndex].methodName!;
    }

    if (offlinePaymentModel!.offlineMethods != null &&
        offlinePaymentModel!.offlineMethods!.isNotEmpty &&
        offlinePaymentModel!
            .offlineMethods![index].methodInformations!.isNotEmpty) {
      for (int i = 0;
          i <
              offlinePaymentModel!
                  .offlineMethods![index].methodInformations!.length;
          i++) {
        inputFieldControllerList.add(TextEditingController());
        keyList.add(offlinePaymentModel!
            .offlineMethods![index].methodInformations![i].customerInput);
      }
    }
    if (notify) {
      notifyListeners();
    }
  }

  Future<ApiResponse> digitalPaymentPlaceOrder(
      {String? orderNote,
      String? customerId,
      String? addressId,
      String? billingAddressId,
      String? couponCode,
      String? couponDiscount,
      String? paymentMethod}) async {
    _isLoading = true;

    ApiResponse apiResponse =
        await checkoutServiceInterface.digitalPaymentPlaceOrder(
            orderNote,
            customerId,
            addressId,
            billingAddressId,
            couponCode,
            couponDiscount,
            paymentMethod,
            _isCheckCreateAccount,
            passwordController.text.trim());
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _addressIndex = null;
      _billingAddressIndex = null;
      sameAsBilling = false;
      _isLoading = false;
      Navigator.pushReplacement(
          Get.context!,
          MaterialPageRoute(
              builder: (_) => DigitalPaymentScreen(
                  url: apiResponse.response?.data['redirect_link'])));
    } else if (apiResponse.error == 'Already registered ') {
      _isLoading = false;
      showCustomSnackBar(
          '${getTranslated(apiResponse.error, Get.context!)}', Get.context!);
    } else {
      _isLoading = false;
      showCustomSnackBar(
          '${getTranslated('payment_method_not_properly_configured', Get.context!)}',
          Get.context!);
    }
    notifyListeners();
    return apiResponse;
  }

  bool sameAsBilling = false;
  void setSameAsBilling() {
    sameAsBilling = !sameAsBilling;
    notifyListeners();
  }

  void clearData() {
    orderNoteController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _isCheckCreateAccount = false;
    _cashChangesAmount = null;
  }

  void setIsCheckCreateAccount(bool isCheck, {bool update = true}) {
    _isCheckCreateAccount = isCheck;
    if (update) {
      notifyListeners();
    }
  }

  void toggleChangeAmountShow() {
    _changeAmountShow = !_changeAmountShow;
    notifyListeners();
  }

  void onChangeCashChangesAmount(double? amount) => _cashChangesAmount = amount;
}
