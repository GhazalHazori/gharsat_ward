import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:gharsat_ward/features/auth/controllers/auth_controller.dart';
import 'package:gharsat_ward/features/invoice/domins/models/pre_invoice.dart';
import 'package:gharsat_ward/main.dart';
import 'package:gharsat_ward/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PreInvoiceController with ChangeNotifier {
  PreInvoice? _preInvoice;
  bool _isLoading = false;
  String? _error;

  PreInvoice? get preInvoice => _preInvoice;
  bool get isLoading => _isLoading;
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
  void clear() {
    _preInvoice = null;
    _error = null;
    notifyListeners();
  }
}
