import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mobile/core/error/error.dart';
import 'package:mobile/features/product/domain/repositories/product_repository.dart';
import 'package:mobile/features/product/infrastructure/data_sources/product_remote_data_source.dart';
import 'package:mobile/features/product/infrastructure/dtos/product_dto.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  const ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppError, ProductDto>> postProduct() async {
    try {
      final result = await _remoteDataSource.postProduct();
      return Right(result);
    } on DioException catch (e, t) {
      return Left(AppError.fromNetwork(
        message: e.message,
        error: e,
        trace: t,
      ));
    } catch (e, t) {
      return Left(AppError.fromUnknown(
        error: e,
        trace: t,
      ));
    }
  }
}
