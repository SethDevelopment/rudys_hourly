import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ----------------------------
// Product Model
// ----------------------------
class Product extends HiveObject {
  String name;
  int qtyProofer;
  int qtyPit;
  int qtyOyler;
  int qtyCook;

  Product({
    required this.name,
    this.qtyProofer = 0,
    this.qtyPit = 0,
    this.qtyOyler = 0,
    this.qtyCook = 0,
  });
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      name: fields[0] as String,
      qtyProofer: fields[1] as int? ?? 0,
      qtyPit: fields[2] as int? ?? 0,
      qtyOyler: fields[3] as int? ?? 0,
      qtyCook: fields[4] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.qtyProofer)
      ..writeByte(2)
      ..write(obj.qtyPit)
      ..writeByte(3)
      ..write(obj.qtyOyler)
      ..writeByte(4)
      ..write(obj.qtyCook);
  }
}

// ----------------------------
// History Model
// ----------------------------
class HistoryEntry extends HiveObject {
  String productName;
  int qtyProofer;
  int qtyPit;
  int qtyOyler;
  int qtyCook;
  DateTime timestamp;

  HistoryEntry({
    required this.productName,
    required this.qtyProofer,
    required this.qtyPit,
    required this.qtyOyler,
    required this.qtyCook,
    required this.timestamp,
  });
}

class HistoryEntryAdapter extends TypeAdapter<HistoryEntry> {
  @override
  final int typeId = 1;

  @override
  HistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryEntry(
      productName: fields[0] as String,
      qtyProofer: fields[1] as int? ?? 0,
      qtyPit: fields[2] as int? ?? 0,
      qtyOyler: fields[3] as int? ?? 0,
      qtyCook: fields[4] as int? ?? 0,
      timestamp: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.qtyProofer)
      ..writeByte(2)
      ..write(obj.qtyPit)
      ..writeByte(3)
      ..write(obj.qtyOyler)
      ..writeByte(4)
      ..write(obj.qtyCook)
      ..writeByte(5)
      ..write(obj.timestamp);
  }
}

// ----------------------------
// Main
// ----------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProductAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(HistoryEntryAdapter());

  final productBox = await Hive.openBox<Product>('products');
  await Hive.openBox<HistoryEntry>('historyBox');

  // Seed products if empty
  if (productBox.isEmpty) {
    final names = [
      'Cobbler',
      'P-Loin',
      'Baby',
      'P-Ribs',
      'Turkey',
      'Birds',
      'Bakers',
      'Brisket',
      'Regs',
      'Hotties',
      'Cheddar',
      'Cob Corn',
      'Butter',
      'New Pots',
      'Cream Corn',
      'Chop',
      'Beans',
      'GCS hot',
      'Pulled Pork',
      'Pork Butts',
      'Prime Rib',
      'AJU SAUCE',
      "Mac N' Cheese",
    ];
    for (final n in names) {
      await productBox.add(Product(name: n));
    }
  }

  runApp(const MaterialApp(home: RudysHome()));
}

// ----------------------------
// Home with Bottom Navigation
// ----------------------------
class RudysHome extends StatefulWidget {
  const RudysHome({super.key});

  @override
  State<RudysHome> createState() => _RudysHomeState();
}

class _RudysHomeState extends State<RudysHome> {
  int _selectedIndex = 0;
  final _pages = [
    const ProductTablePage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.table_rows), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

// ----------------------------
// Product Table Page
// ----------------------------
class ProductTablePage extends StatelessWidget {
  const ProductTablePage({super.key});

  Future<void> _editQty(
      BuildContext context, Product product, String field) async {
    int currentQty;
    switch (field) {
      case 'Proofer':
        currentQty = product.qtyProofer;
        break;
      case 'Pit':
        currentQty = product.qtyPit;
        break;
      case 'Oyler':
        currentQty = product.qtyOyler;
        break;
      case 'Cook':
        currentQty = product.qtyCook;
        break;
      default:
        currentQty = 0;
    }

    final controller = TextEditingController();

    final result = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Update ${product.name} • $field'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: currentQty.toString(), // old value as hint
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final parsed = int.tryParse(controller.text);
              Navigator.pop(context, parsed ?? currentQty);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      switch (field) {
        case 'Proofer':
          product.qtyProofer = result;
          break;
        case 'Pit':
          product.qtyPit = result;
          break;
        case 'Oyler':
          product.qtyOyler = result;
          break;
        case 'Cook':
          product.qtyCook = result;
          break;
      }
      await product.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Product>('products');
    return Scaffold(
      appBar: AppBar(title: const Text('Kitchen Inventory')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Product> products, _) {
          final items = products.values.toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 750),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Product')),
                    DataColumn(label: Text('Proofer')),
                    DataColumn(label: Text('Pit')),
                    DataColumn(label: Text('Oyler')),
                    DataColumn(label: Text('Total')), // total column
                    DataColumn(label: Text('Cook')),
                  ],
                  rows: items.map((p) {
                    final total = p.qtyProofer + p.qtyPit + p.qtyOyler;
                    return DataRow(
                      cells: [
                        DataCell(Text(p.name)),
                        DataCell(Text(p.qtyProofer.toString()),
                            onTap: () => _editQty(context, p, 'Proofer')),
                        DataCell(Text(p.qtyPit.toString()),
                            onTap: () => _editQty(context, p, 'Pit')),
                        DataCell(Text(p.qtyOyler.toString()),
                            onTap: () => _editQty(context, p, 'Oyler')),
                        DataCell(Text(total.toString())), // Total
                        DataCell(Text(p.qtyCook.toString()),
                            onTap: () => _editQty(context, p, 'Cook')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save),
        label: const Text('Save to History'),
        onPressed: () async {
          final productBox = Hive.box<Product>('products');
          final historyBox = Hive.box<HistoryEntry>('historyBox');

          for (final product in productBox.values) {
            // save to history
            await historyBox.add(HistoryEntry(
              productName: product.name,
              qtyProofer: product.qtyProofer,
              qtyPit: product.qtyPit,
              qtyOyler: product.qtyOyler,
              qtyCook: product.qtyCook,
              timestamp: DateTime.now(),
            ));

            // reset values
            product.qtyProofer = 0;
            product.qtyPit = 0;
            product.qtyOyler = 0;
            product.qtyCook = 0;

            await product.save();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('All products saved to history and reset')),
          );
        },
      ),
    );
  }
}

// ----------------------------
// History Page
// ----------------------------
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<HistoryEntry>('historyBox');

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<HistoryEntry> historyBox, _) {
          final entries = historyBox.values.toList().reversed.toList();

          // Track latest timestamp per product
          final latestPerProduct = <String, DateTime>{};
          for (final e in entries) {
            if (!latestPerProduct.containsKey(e.productName) ||
                e.timestamp.isAfter(latestPerProduct[e.productName]!)) {
              latestPerProduct[e.productName] = e.timestamp;
            }
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalController,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 750),
              child: SingleChildScrollView(
                controller: _verticalController,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('Product')),
                    DataColumn(label: Text('Proofer')),
                    DataColumn(label: Text('Pit')),
                    DataColumn(label: Text('Oyler')),
                    DataColumn(label: Text('Cook')),
                  ],
                  rows: entries.map((e) {
                    final isMostRecentForProduct =
                        e.timestamp == latestPerProduct[e.productName];
                    return DataRow(
                      color: isMostRecentForProduct
                          ? MaterialStateProperty.all(Colors.yellow[200])
                          : null,
                      cells: [
                        DataCell(Text(
                            '${e.timestamp.year}-${e.timestamp.month.toString().padLeft(2, '0')}-${e.timestamp.day.toString().padLeft(2, '0')} ${e.timestamp.hour.toString().padLeft(2, '0')}:${e.timestamp.minute.toString().padLeft(2, '0')}')),
                        DataCell(Text(e.productName)),
                        DataCell(Text(e.qtyProofer.toString())),
                        DataCell(Text(e.qtyPit.toString())),
                        DataCell(Text(e.qtyOyler.toString())),
                        DataCell(Text(e.qtyCook.toString())),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
