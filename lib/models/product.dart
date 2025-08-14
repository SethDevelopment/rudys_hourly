import 'package:hive/hive.dart';
part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> locations;

  @HiveField(2)
  bool active;

  Product({
    required this.name,
    required this.locations,
    this.active = true,
  });
}
