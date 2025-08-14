import 'package:hive/hive.dart';
import 'product.dart';
part 'check.g.dart';

@HiveType(typeId: 1)
class CheckItem extends HiveObject {
  @HiveField(0)
  Product product;

  @HiveField(1)
  int quantity;

  CheckItem({required this.product, required this.quantity});
}

@HiveType(typeId: 2)
class CheckEntry extends HiveObject {
  @HiveField(0)
  DateTime timestamp;

  @HiveField(1)
  List<CheckItem> items;

  @HiveField(2)
  String? note;

  CheckEntry({required this.timestamp, required this.items, this.note});
}
