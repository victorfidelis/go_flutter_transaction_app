import 'package:flutter/material.dart';

class TransactionDetailView extends StatelessWidget {
  const TransactionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhe de transação')),
      body: Center(child: Text('TRANSAÇÃO')),
    );
  }
}
