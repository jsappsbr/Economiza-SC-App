import 'package:flutter/material.dart';

class FullImageModal extends StatelessWidget {
  const FullImageModal({super.key, required this.url, required this.productName});

  final String url;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(productName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(url),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Fechar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
