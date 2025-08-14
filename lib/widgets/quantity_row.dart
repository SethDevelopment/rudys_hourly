import 'package:flutter/material.dart';
import '../models/product.dart';

class QuantityRow extends StatelessWidget {
  final Product product;
  final TextEditingController controller;

  QuantityRow({required this.product, Key? key})
      : controller = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(product.name, style: TextStyle(fontSize: 18))),
        Container(
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "",
            ),
          ),
        ),
      ],
    );
  }
}
