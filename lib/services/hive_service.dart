import 'package:hive/hive.dart';
import '../models/product.dart';
import '../models/check.dart';

class HiveService {
  static Box<Product> get productBox => Hive.box<Product>('products');
  static Box<CheckEntry> get checkBox => Hive.box<CheckEntry>('checks');

  static List<Product> getAllProducts() => productBox.values.toList();

  static Future<void> addProduct(Product p) async => await productBox.add(p);

  static Future<void> addCheck(CheckEntry c) async => await checkBox.add(c);

  static List<CheckEntry> getAllChecks() => checkBox.values.toList();
}
