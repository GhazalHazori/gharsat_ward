import 'package:gharsat_ward/interface/repo_interface.dart';

abstract class ReOrderRepositoryInterface<T> extends RepositoryInterface {
  Future<dynamic> reorder(String orderId);
}
