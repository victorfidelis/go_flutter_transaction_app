import 'package:flutter/material.dart';

class PendingTransactionView extends StatelessWidget {
  const PendingTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Transações pendentes'),),
    );
  }
}