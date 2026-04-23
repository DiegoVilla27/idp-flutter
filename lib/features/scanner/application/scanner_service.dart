import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../products/domain/product.dart';
import 'idp_processor.dart';

class ScannerService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<Product?> scanImage(InputImage inputImage) async {
    try {
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      final rawText = recognizedText.text;
      
      debugPrint('--- RAW OCR TEXT START ---');
      debugPrint(rawText);
      debugPrint('--- RAW OCR TEXT END ---');
      
      if (rawText.trim().isEmpty) return null;
      
      return IDPProcessor.processRawText(rawText);
    } catch (e) {
      // Log error in a real app
      return null;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
