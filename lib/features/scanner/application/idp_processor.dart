import '../../products/domain/product.dart';

class IDPProcessor {
  /// Parses raw text extracted from OCR into a [Product] object.
  static Product processRawText(String rawText) {
    // Split into lines and cleanup noise
    final lines = rawText.split('\n').map((l) => l.trim()).where((l) => l.length > 1).toList();
    
    String? name;
    String? description;
    String? id;
    int quantity = 1;
    double? price;

    // Helper map to store found values by label
    final Map<String, String> labeledValues = {};
    
    // Much more flexible label detection (allows optional leading noise and spaces)
    // Captures everything after keywords like "id", "name", etc.
    final labelRegex = RegExp(
      r'(?:^|[\s\-_])(id|name|nombre|description|descripcion|price|precio|quantity|qty|cant|cantidad)[\s\-_:]+(.+)$', 
      caseSensitive: false
    );

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final match = labelRegex.firstMatch(line);
      
      if (match != null) {
        final label = match.group(1)!.toLowerCase();
        String value = match.group(2)?.trim() ?? '';
        
        // If the value is empty on the current line, look at the next line
        if (value.isEmpty && i + 1 < lines.length) {
          value = lines[i + 1].trim();
        }

        if (value.isNotEmpty) {
          // Map common labels to standardized keys
          if (label.contains('nombre')) labeledValues['name'] = value;
          else if (label.contains('descripcion')) labeledValues['description'] = value;
          else if (label.contains('precio')) labeledValues['price'] = value;
          else if (label.contains('cant') || label.contains('cantidad')) labeledValues['quantity'] = value;
          else labeledValues[label] = value;
        }
      }
    }

    // 1. Assign and Clean from labeled values
    id = labeledValues['id'];
    name = labeledValues['name'];
    description = labeledValues['description'];
    
    if (labeledValues.containsKey('price')) {
      price = _extractNumeric(labeledValues['price']!);
    }
    
    if (labeledValues.containsKey('quantity')) {
      final q = _extractNumeric(labeledValues['quantity']!);
      if (q != null) quantity = q.toInt();
    }

    // 2. Fallbacks for unlabelled data
    if (price == null) {
      for (var line in lines) {
        if (line.contains('\$') || RegExp(r'\d+[.,]\d{2}').hasMatch(line)) {
          price = _extractNumeric(line);
          if (price != null) break;
        }
      }
    }

    if (id == null) {
      final idFallback = RegExp(r'(?:ID|SKU|REF)[\s:]*([A-Z0-9-]+)', caseSensitive: false);
      for (var line in lines) {
        final match = idFallback.firstMatch(line);
        if (match != null) {
          id = match.group(1);
          break;
        }
      }
    }

    // Final cleanup of Name
    if (name != null) {
      // Basic OCR correction for double letters if common matches exist
      // (Optional: Implement a real spellchecker here if needed)
      name = name.replaceAll(RegExp(r'\s+'), ' ').trim();
    } else if (lines.isNotEmpty) {
      // Improved fallback for name: first line that doesn't look like ID or Price
      name = lines.firstWhere(
        (l) => !l.contains(':') && l.length > 3 && !RegExp(r'^\d+$').hasMatch(l),
        orElse: () => 'Scanned Product'
      );
    }

    return Product(
      id: id ?? 'SCAN-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: name ?? 'Scanned Product',
      description: description,
      quantity: quantity,
      price: price,
      scannedAt: DateTime.now(),
    );
  }

  /// Extracts the first valid numeric value from a string, handling OCR confusion
  static double? _extractNumeric(String text) {
    // Replace OCR errors: S->5, l->1, I->1, O->0, z->2
    String cleaned = text.toUpperCase()
        .replaceAll('S', '5')
        .replaceAll('L', '1')
        .replaceAll('I', '1')
        .replaceAll('O', '0')
        .replaceAll('Z', '2');
        
    // Extract only digits and decimal separators
    final numericPart = cleaned.replaceAll(RegExp(r'[^\d.,]'), '');
    if (numericPart.isEmpty) return null;
    
    // Normalize decimal separator (comma to dot)
    final normalized = numericPart.replaceAll(',', '.');
    
    // If there are multiple dots, keep only the last one for decimals
    final parts = normalized.split('.');
    if (parts.length > 2) {
      final whole = parts.sublist(0, parts.length - 1).join('');
      final decimal = parts.last;
      return double.tryParse('$whole.$decimal');
    }
    
    return double.tryParse(normalized);
  }
}
