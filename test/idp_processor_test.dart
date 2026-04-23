import 'package:flutter_test/flutter_test.dart';
import 'package:idp_flutter/features/scanner/application/idp_processor.dart';

void main() {
  group('IDPProcessor Tests', () {
    test('should parse a typical invoice string correctly', () {
      const rawText = '''
PRODUCT: Premium Wireless Mouse
REF: SKU-990-AB
PRICE: \$45.00
QTY: 2
Made in China
''';

      final product = IDPProcessor.processRawText(rawText);

      expect(product.name, 'Premium Wireless Mouse');
      expect(product.id, 'SKU-990-AB');
      expect(product.price, 45.00);
      expect(product.quantity, 2);
    });

    test('should handle minimal input with default values', () {
      const rawText = 'Just a name';
      
      final product = IDPProcessor.processRawText(rawText);

      expect(product.name, 'Just a name');
      expect(product.id, startsWith('SCAN-'));
      expect(product.quantity, 1);
      expect(product.price, isNull);
    });

    test('should extract price from complex lines', () {
      const rawText = 'Total amount to pay is 120.50 EUR';
      
      final product = IDPProcessor.processRawText(rawText);

      expect(product.price, 120.50);
    });
  });
}
