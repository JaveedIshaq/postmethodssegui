part of 'product_cubit.dart';

class ProductState extends BaseState {
  final ProductEntity? product;
  final String message;

  @override
  final RequestStatus submitStatus;

  const ProductState({
    this.submitStatus = RequestStatus.initial,
    this.message = "",
    this.product,
  });

  factory ProductState.initial() => const ProductState(
        submitStatus: RequestStatus.initial,
        message: '',
        product: null,
      );

  @override
  List<Object?> get props => [submitStatus, message, product];

  @override
  ProductState copyWith({
    RequestStatus? submitStatus,
    String? message,
    ProductEntity? product,
  }) {
    return ProductState(
      submitStatus: submitStatus ?? this.submitStatus,
      message: message ?? this.message,
      product: product ?? this.product,
    );
  }
}
