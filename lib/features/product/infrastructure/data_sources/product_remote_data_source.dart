import 'package:injectable/injectable.dart';
import 'package:mobile/core/network/network.dart';
import 'package:mobile/features/product/infrastructure/dtos/product_dto.dart';

@lazySingleton
class ProductRemoteDataSource {
  final Network _network;

  ProductRemoteDataSource(this._network);

  Future<ProductDto> postProduct() async {
    final response =
        await _network.post('https://api.restful-api.dev/objects', {
      "name": "Apple MacBook Pro 16",
      "data": {
        "year": 2019,
        "price": 1849.99,
        "CPU model": "Intel Core i9",
        "Hard disk size": "1 TB"
      }
    });
    return ProductDto.fromJson(response.data);
  }
}
