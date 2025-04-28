import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:transaction_app/app/core/widgets/custom_loading.dart';
import 'package:transaction_app/app/core/widgets/custom_text_error.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/new_transaction_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/custom_date_field.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/custom_text_filed.dart';

class NewTransactionView extends StatelessWidget {
  final NewTransactionStore store;

  const NewTransactionView({super.key, required this.store});

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
    return Padding(padding: const EdgeInsets.all(16.0), child: _buildForm());
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
        Observer(
          builder: (context) {
            return CustomTextFiled(
              labelText: 'Descrição',
              errorText: store.descriptionError,
              onChanged: store.setDescription,
            );
          },
        ),
        const SizedBox(height: 16),
        Observer(
          builder: (context) {
            return CustomTextFiled(
              hintText: 'Valor (USD)',
              isMoney: true,
              errorText: store.amountError,
              onChanged: store.setAmount,
            );
          },
        ),
        const SizedBox(height: 16),
        Observer(
          builder: (context) {
            return CustomDateField(
              labelText: 'Data',
              errorText: store.dateError,
              onChanged: store.setDate,
            );
          },
        ),
        Observer(
          builder: (context) {
            return _buildGenericErrorMessage();
          }
        ),
        Observer(
          builder: (context) {
            if (store.isLoading) {
              return Center(child: CustomLoading());
            }
            if (store.transactionCreated) {
              return SizedBox();
            }
            return ElevatedButton(
              onPressed: store.createTransaction,
              child: const Text('Salvar Transação'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGenericErrorMessage() {
    if (store.error == null) {
      return SizedBox(height: 24);
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: CustomTextError(message: store.error!),
    );
  }
}
