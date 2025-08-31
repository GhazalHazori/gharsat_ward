import 'package:gharsat_ward/interface/repo_interface.dart';

abstract class BrandRepoInterface<T> implements RepositoryInterface {
  Future<dynamic> getBrandList(int offset);

  Future<dynamic> getSellerWiseBrandList(int sellerId);
}
