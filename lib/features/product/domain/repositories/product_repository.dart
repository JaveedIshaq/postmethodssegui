import 'package:dartz/dartz.dart';
import 'package:mobile/core/error/error.dart';
import 'package:mobile/features/product/infrastructure/dtos/product_dto.dart';

abstract class ProductRepository {
  Future<Either<AppError, ProductDto>> postProduct();
}
