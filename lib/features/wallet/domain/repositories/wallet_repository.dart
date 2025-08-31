import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gharsat_ward/data/datasource/remote/dio/dio_client.dart';
import 'package:gharsat_ward/data/datasource/remote/exception/api_error_handler.dart';
import 'package:gharsat_ward/data/model/api_response.dart';
import 'package:gharsat_ward/features/splash/controllers/splash_controller.dart';
import 'package:gharsat_ward/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:gharsat_ward/helper/date_converter.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/utill/app_constants.dart';
import 'package:provider/provider.dart';

class WalletRepository implements WalletRepositoryInterface {
  final DioClient? dioClient;
  WalletRepository({required this.dioClient});

  @override
 Future getList({
  int? offset = 1,
  int limit = 10,
  int? oldestUnpaid,
  int? overdue,
  String? filterBy,
  DateTime? startDate,
  DateTime? endDate,
  List<String>? transactionTypes,
}) async {
  // Build query parameters dynamically
  final Map<String, dynamic> queryParams = {
    'offset': offset,
    'limit': limit,
    if (oldestUnpaid != null) 'oldest_unpaid': oldestUnpaid, // 👈 جديد
    if (overdue != null) 'overdue': overdue,                 // 👈 بقى موجود
    if (filterBy != null && filterBy.isNotEmpty) 'filter_by': filterBy,
    if (startDate != null)
      'start_date': DateConverter.durationDateTime(startDate),
    if (endDate != null) 'end_date': DateConverter.durationDateTime(endDate),
    if (transactionTypes != null && transactionTypes.isNotEmpty)
      'transaction_types': jsonEncode(transactionTypes),
  };

  debugPrint('--------(WALLET_QUERY_PARAMS)----$queryParams');

  try {
    Response response = await dioClient!.get(
      AppConstants.walletTransactionUri,
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      debugPrint('--------(WALLET_RESPONSE_STATUS)----${response.statusCode}');
      debugPrint('--------(WALLET_RESPONSE_DATA)----$data');

      if (data['wallet_transaction_list'] != null &&
          data['wallet_transaction_list'] is List) {
        final List transactions = data['wallet_transaction_list'];
        debugPrint(
            '--------(WALLET_TRANSACTIONS_COUNT)----${transactions.length}');
        debugPrint('--------(WALLET_TRANSACTIONS_LIST)----$transactions');
      } else {
        debugPrint('--------(NO_TRANSACTIONS_LIST_FOUND)----');
      }
    } else {
      debugPrint(
          '--------(WALLET_RESPONSE_ERROR)----Status: ${response.statusCode}');
    }

    return ApiResponse.withSuccess(response);
  } catch (e) {
    return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  }
}


  // @override
  // Future<ApiResponse> getWalletTransactionList(int offset, String types, String startDate, String endDate, String filterByType) async {
  //   try {
  //     Response response = await dioClient!.get('${AppConstants.walletTransactionUri}$offset&transaction_types=$types&start_date=$startDate&end_date=$endDate&filter_by=$filterByType');
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }

  @override
  Future<ApiResponse> addFundToWallet(
      String amount, String paymentMethod) async {
    try {
      final response =
          await dioClient!.post(AppConstants.addFundToWallet, data: {
        'payment_platform': 'app',
        'payment_method': paymentMethod,
        'payment_request_from': 'app',
        'amount': amount,
        'current_currency_code':
            Provider.of<SplashController>(Get.context!, listen: false)
                .myCurrency!
                .code
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getWalletBonusBannerList() async {
    try {
      Response response = await dioClient!.get(AppConstants.walletBonusList);
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
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  void _showOverduePaymentPopup() {
    debugPrint('--------(SHOWING_OVERDUE_POPUP_METHOD)----');
    // Show popup using Navigator
    if (Get.context != null) {
      debugPrint('--------(CONTEXT_AVAILABLE)----');
      showDialog(
        context: Get.context!,
        barrierDismissible: false, // User must take action
        builder: (BuildContext context) {
          debugPrint('--------(BUILDING_DIALOG)----');
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
                  debugPrint('--------(POPUP_OK_PRESSED)----');
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      debugPrint('--------(CONTEXT_NOT_AVAILABLE)----');
    }
  }
}
