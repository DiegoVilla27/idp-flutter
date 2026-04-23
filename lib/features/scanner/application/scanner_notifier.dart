import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../products/presentation/providers/product_list_provider.dart';
import 'scanner_service.dart';

part 'scanner_notifier.g.dart';

@riverpod
class ScannerNotifier extends _$ScannerNotifier {
  late ScannerService _scannerService;
  bool _isProcessing = false;

  @override
  FutureOr<void> build() {
    _scannerService = ScannerService();
    ref.onDispose(() => _scannerService.dispose());
  }

  Future<bool> processImage(XFile image) async {
    if (_isProcessing) return false;
    _isProcessing = true;

    try {
      // 1. USE RAW IMAGE DIRECTLY (Filters were breaking compatibility)
      final testPath = image.path;

      // 2. Scan the RAW image
      final inputImage = InputImage.fromFilePath(testPath);
      final product = await _scannerService.scanImage(inputImage);

      if (product != null) {
        ref.read(productListProvider.notifier).addProduct(product);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('IDP Error: $e');
      return false;
    } finally {
      _isProcessing = false;
    }
  }
}
