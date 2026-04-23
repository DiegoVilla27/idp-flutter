import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/product.dart';

part 'product_list_provider.g.dart';

@riverpod
class ProductList extends _$ProductList {
  @override
  List<Product> build() => [];

  void addProduct(Product product) {
    // Check if product already exists (by ID) to avoid duplicates
    final exists = state.any((p) => p.id == product.id);
    if (!exists) {
      state = [product, ...state];
    }
  }

  void removeProduct(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  void clear() {
    state = [];
  }
}
