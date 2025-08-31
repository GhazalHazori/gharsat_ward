import 'package:gharsat_ward/interface/repo_interface.dart';

abstract class WalletRepositoryInterface<T> extends RepositoryInterface {
  // Future<dynamic> getWalletTransactionList(int offset, String types, String startDate, String endDate, String filterByType);

  Future<dynamic> addFundToWallet(String amount, String paymentMethod);

  Future<dynamic> getWalletBonusBannerList();

  @override
  Future<dynamic> getList(
      {int? offset = 1,
      String? filterBy,
      DateTime? startDate,
      DateTime? endDate, int? oldestUnpaid,
      List<String>? transactionTypes});
}
