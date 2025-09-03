import 'package:flutter/material.dart';
import 'package:gharsat_ward/data/model/api_response.dart';
import 'package:gharsat_ward/features/wallet/domain/models/wallet_transaction_model.dart';
import 'package:gharsat_ward/features/wallet/domain/models/wallet_bonus_model.dart';
import 'package:gharsat_ward/features/wallet/domain/services/wallet_service_interface.dart';
import 'package:gharsat_ward/features/wallet/screens/add_fund_to_wallet_screen.dart';
import 'package:gharsat_ward/helper/api_checker.dart';
import 'package:gharsat_ward/helper/price_converter.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/common/basewidget/show_custom_snakbar_widget.dart';

class WalletController extends ChangeNotifier {
  final WalletServiceInterface walletServiceInterface;
  WalletController({required this.walletServiceInterface});

  bool _isLoading = false;
  bool _firstLoading = false;
  bool _isConvert = false;
  bool get isConvert => _isConvert;
  bool get isLoading => _isLoading;
  bool get firstLoading => _firstLoading;
  int? _transactionPageSize;
  int? get transactionPageSize => _transactionPageSize;
  WalletTransactionModel? _walletTransactionModel;
  WalletTransactionModel? get walletTransactionModel => _walletTransactionModel;

  DateTime? _startDate;
  DateTime? get startDate => _startDate;

  DateTime? _endDate;
  DateTime? get endDate => _endDate;

  String? _selectedFilterBy;
  String? get selectedFilterBy => _selectedFilterBy;

  Set<String>? _selectedEarnByList;
  Set<String>? get selectedEarnByList => _selectedEarnByList;

  Future<void> getTransactionList(
    int offset, {
    bool reload = false,
    bool isUpdate = true,
    String? filterBy,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? transactionTypes,
  }) async {
    if (reload || offset == 1) {
      _walletTransactionModel = null;

      if (isUpdate) {
        notifyListeners();
      }
    }

    ApiResponse apiResponse = await walletServiceInterface.getList(
      offset: offset,
      filterBy: filterBy,
      startDate: startDate,
      endDate: endDate,
      transactionTypes: transactionTypes,
    );

    if (apiResponse.response?.data != null &&
        apiResponse.response?.statusCode == 200) {
      if (offset == 1) {
        _walletTransactionModel =
            WalletTransactionModel.fromJson(apiResponse.response?.data);
      } else {
        _walletTransactionModel?.offset =
            WalletTransactionModel.fromJson(apiResponse.response?.data).offset;
        _walletTransactionModel?.totalWalletBalance =
            WalletTransactionModel.fromJson(apiResponse.response?.data)
                .totalWalletBalance;
        _walletTransactionModel?.totalSize =
            WalletTransactionModel.fromJson(apiResponse.response?.data)
                .totalSize;
        _walletTransactionModel?.walletTransactionList?.addAll(
            WalletTransactionModel.fromJson(apiResponse.response?.data)
                    .walletTransactionList ??
                []);
      }

      // Check for overdue payments after successful data loading
      if (offset == 1) {
        // Only check on first load to avoid multiple popups
        debugPrint('--------(FIRST_LOAD_CHECKING_OVERDUE)----');
        showOverduePaymentPopup();
      }
    } else {
      _walletTransactionModel?.walletTransactionList = [];
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }
  /// دالة جديدة لجلب المعاملات فقط بالـ oldest_unpaid, offset, limit
  Future<void> getOldestUnpaidTransactions({
    required int offset,
    int limit = 100,
    int oldestUnpaid = 1,
  }) async {
    _walletTransactionModel = null;
    notifyListeners();

    ApiResponse apiResponse = await walletServiceInterface.getList(
      offset: offset,
      
      oldestUnpaid: oldestUnpaid,
    );

    if (apiResponse.response?.data != null &&
        apiResponse.response?.statusCode == 200) {
      _walletTransactionModel =
          WalletTransactionModel.fromJson(apiResponse.response?.data);

      debugPrint(
          '--------(OLDEST_UNPAID_TRANSACTIONS_LOADED)----count: ${_walletTransactionModel?.walletTransactionList?.length}');
    } else {
      _walletTransactionModel?.walletTransactionList = [];
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
  }
  //   Future<void> getOverdueTransactions({
  //   required int offset,
  //   int limit = 100,
  //   int oldestUnpaid = 1,
  // }) async {
  //   _walletTransactionModel = null;
  //   notifyListeners();

  //   ApiResponse apiResponse = await walletServiceInterface.getList(
  //     offset: offset,
      
  //     overdue: oldestUnpaid,
  //   );

  //   if (apiResponse.response?.data != null &&
  //       apiResponse.response?.statusCode == 200) {
  //     _walletTransactionModel =
  //         WalletTransactionModel.fromJson(apiResponse.response?.data);

  //     debugPrint(
  //         '--------(OLDEST_UNPAID_TRANSACTIONS_LOADED)----count: ${_walletTransactionModel?.walletTransactionList?.length}');
  //   } else {
  //     _walletTransactionModel?.walletTransactionList = [];
  //     ApiChecker.checkApi(apiResponse);
  //   }

  //   notifyListeners();
  // }
  

  Future<void> addFundToWallet(String amount, String paymentMethod) async {
    _isConvert = true;
    notifyListeners();
    ApiResponse apiResponse =
        await walletServiceInterface.addFundToWallet(amount, paymentMethod);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isConvert = false;
      Navigator.pushReplacement(
          Get.context!,
          MaterialPageRoute(
              builder: (_) => AddFundToWalletScreen(
                  url: apiResponse.response?.data['redirect_link'])));
    } else if (apiResponse.response?.statusCode == 202) {
      showCustomSnackBar(
          "Minimum= ${PriceConverter.convertPrice(Get.context!, double.tryParse('${apiResponse.response?.data['minimum_amount']}'))} and Maximum=${PriceConverter.convertPrice(Get.context!, double.tryParse('${apiResponse.response?.data['maximum_amount']}'))}",
          Get.context!);
    } else {
      _isConvert = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  WalletBonusModel? walletBonusModel;
  Future<void> getWalletBonusBannerList() async {
    ApiResponse apiResponse =
        await walletServiceInterface.getWalletBonusBannerList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      walletBonusModel = WalletBonusModel.fromJson(apiResponse.response?.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  int currentIndex = 0;
  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<void> setSelectedDate(
      {required DateTime? startDate, required DateTime? endDate}) async {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }

  void setSelectedProductType({String? type, bool isUpdate = true}) {
    _selectedFilterBy = type;

    if (isUpdate) {
      notifyListeners();
    }
  }

  void onUpdateEarnBy(String value, {bool isUpdate = true}) {
    _selectedEarnByList ??= <String>{};

    // Toggle logic
    if (!_selectedEarnByList!.add(value)) {
      _selectedEarnByList!.remove(value);
    }

    if (isUpdate) {
      notifyListeners();
    }
  }

  void initFilterData() {
    _selectedFilterBy = _walletTransactionModel?.filterBy;
    _selectedEarnByList = _walletTransactionModel?.transactionTypes?.toSet();

    _startDate = _walletTransactionModel?.startDate;
    _endDate = _walletTransactionModel?.endDate;
  }

  /// Check if there are any unpaid transactions in the wallet
  bool hasUnpaidTransactions() {
    debugPrint('--------(CHECKING_UNPAID_TRANSACTIONS)----');
    if (_walletTransactionModel?.walletTransactionList == null) {
      debugPrint('--------(NO_TRANSACTION_MODEL)----');
      return false;
    }

    final hasUnpaid =
        _walletTransactionModel!.walletTransactionList!.any((transaction) {
      final isPaid = transaction.isPaid;
      debugPrint(
          '--------(CONTROLLER_TRANSACTION_CHECK)----ID: ${transaction.id}, isPaid: $isPaid');
      return isPaid == 0;
    });

    debugPrint('--------(CONTROLLER_HAS_UNPAID)----$hasUnpaid');
    return hasUnpaid;
  }

  /// Show overdue payment popup if there are unpaid transactions
  void showOverduePaymentPopup() {
    debugPrint('--------(CONTROLLER_SHOW_OVERDUE_POPUP)----');
    if (hasUnpaidTransactions() && Get.context != null) {
      debugPrint('--------(CONTROLLER_POPUP_CONDITIONS_MET)----');
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          debugPrint('--------(CONTROLLER_BUILDING_DIALOG)----');
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Text('Payment Overdue'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You have unpaid transactions in your wallet.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Please complete your payment to continue using wallet services.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  debugPrint('--------(CONTROLLER_POPUP_OK_PRESSED)----');
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      debugPrint(
          '--------(CONTROLLER_POPUP_CONDITIONS_NOT_MET)----hasUnpaid: ${hasUnpaidTransactions()}, context: ${Get.context != null}');
    }
  }

  /// Check for overdue payments and refresh data if needed
  Future<void> checkOverduePayments() async {
    await getTransactionList(1, reload: true);
  }
}
