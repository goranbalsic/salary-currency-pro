import '../utils/money.dart';

/// One line of an itemized invoice. Optional — an [Invoice] with no
/// items falls back to rendering its own `description`/`amount` as a
/// single implied line, so the existing simple invoice flow is
/// unaffected by this addition.
class InvoiceLineItem {
  final String description;
  final double quantity;
  final double unitPrice;

  const InvoiceLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  /// Rounded once, here, to the nearest cent — see lib/utils/money.dart.
  /// Callers summing multiple lines must sum this integer, never re-derive
  /// it from `quantity * unitPrice` as a raw double.
  int get subtotalMinorUnits => roundToMinorUnits(quantity * unitPrice);

  Map<String, dynamic> toJson() => {
        'description': description,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) => InvoiceLineItem(
        description: json['description'] as String? ?? '',
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      );
}
