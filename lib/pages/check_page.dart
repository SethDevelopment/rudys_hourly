import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/check.dart';
import '../services/hive_service.dart';
import '../widgets/quantity_row.dart';

class CheckPage extends StatefulWidget {
  @override
  _CheckPageState createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, List<QuantityRow>> _rowsByStation = {};
  final List<String> stations = ["Proofer", "Pit", "Oyler"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: stations.length, vsync: this);

    // Generate rows for each station
    for (var station in stations) {
      List<Product> products = HiveService.getAllProducts()
          .where((p) => p.locations.contains(station))
          .toList();
      _rowsByStation[station] =
          products.map((p) => QuantityRow(product: p)).toList();
    }
  }

  void saveCheck() {
    List<CheckItem> allItems = [];
    for (var station in stations) {
      for (var row in _rowsByStation[station]!) {
        final text = row.controller.text.trim();
        if (text.isNotEmpty) {
          int? quantity = int.tryParse(text);
          if (quantity != null) {
            allItems.add(CheckItem(product: row.product, quantity: quantity));
          }
        }
      }
    }

    if (allItems.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter at least one quantity")));
      return;
    }

    HiveService.addCheck(CheckEntry(timestamp: DateTime.now(), items: allItems));

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Check saved!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hourly Check"),
        bottom: TabBar(
          controller: _tabController,
          tabs: stations.map((s) => Tab(text: s)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: stations.map((station) {
          final rows = _rowsByStation[station]!;
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: rows.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (_, index) => rows[index],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveCheck,
        child: Icon(Icons.save),
      ),
    );
  }
}
