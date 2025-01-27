import 'package:mobile/core/cubit/cubit.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/domain/repositories/product_repository.dart';

part 'product_state.dart';

@lazySingleton
class ProductCubit extends BaseCubit<ProductState> {
  final ProductRepository _productRepository;

  ProductCubit(this._productRepository) : super(ProductState.initial());

  Future<void> onPostProduct() async {
    emit(state.copyWith(submitStatus: RequestStatus.loading));
    final result = await _productRepository.postProduct();
    result.fold(
      (error) => emit(state.copyWith(
        submitStatus: RequestStatus.failure,
        message: error.message,
      )),
      (product) => emit(state.copyWith(
        submitStatus: RequestStatus.success,
        product: product.toEntity(),
      )),
    );
  }
}
