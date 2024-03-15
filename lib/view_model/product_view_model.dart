import 'package:task_nxtpe_flutter/model/products_model.dart';
import 'package:task_nxtpe_flutter/repository/product_repository.dart';

class ProductViewModel {
  final _rep = ProductRepository();

  Future<ProductsModel> fetchProductApi() async {
    final response = await _rep.fetchProductApi();
    return response;
  }
}
