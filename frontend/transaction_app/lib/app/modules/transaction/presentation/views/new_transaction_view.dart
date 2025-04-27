import 'package:flutter/material.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/custom_date_field.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/custom_text_filed.dart';

class NewTransactionView extends StatefulWidget {
  const NewTransactionView({super.key});

  @override
  State<NewTransactionView> createState() => _NewTransactionViewState();
}

class _NewTransactionViewState extends State<NewTransactionView> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Transação')),
      body: SingleChildScrollView(child: _buildResponsiveForm()),
    );
  }

  Widget _buildResponsiveForm() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileForm();
        } else {
          return _buildDesktopForm();
        }
      },
    );
  }

  Widget _buildMobileForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildForm(),
    );
  }

  Widget _buildDesktopForm() {
    return Center(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(32),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextFiled(
          controller: _descriptionController,
          labelText: 'Descrição',
        ),
        const SizedBox(height: 16),
        CustomTextFiled(
          controller: _amountController,
          hintText: 'Valor (USD)',
          isMoney: true,
        ),
        const SizedBox(height: 16),
        CustomDateField(labelText: 'Data'),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () {}, child: const Text('Salvar Transação')),
      ],
    );
  }
}
