import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/core/services/nofitication_service.dart';
import 'package:transaction_app/app/core/utils/alphanumeric_input_formatter.dart';
import 'package:transaction_app/app/core/utils/max_length_input_formatter.dart';
import 'package:transaction_app/app/core/utils/money_input_formatter.dart';
import 'package:transaction_app/app/core/widgets/custom_loading.dart';
import 'package:transaction_app/app/core/widgets/custom_text_error.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/new_transaction_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/custom_buttom.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/custom_date_field.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/custom_text_filed.dart';

class NewTransactionView extends StatefulWidget {
  const NewTransactionView({super.key});

  @override
  State<NewTransactionView> createState() => _NewTransactionViewState();
}

class _NewTransactionViewState extends State<NewTransactionView> {
  late final NewTransactionStore store;

  @override
  void initState() {
    store = Modular.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Transação'),
        centerTitle: true,
        toolbarHeight: 100,
      ),
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
              inputFormatters: [
                AlphanumericInputFormatter(),
                MaxLengthInputFormatter(50),
              ],
            );
          },
        ),
        const SizedBox(height: 40),
        Observer(
          builder: (context) {
            return CustomTextFiled(
              labelText: 'Valor (USD)',
              isMoney: true,
              errorText: store.amountError,
              onChanged: store.setAmount,
              inputFormatters: [MoneyInputFormatter()],
            );
          },
        ),
        const SizedBox(height: 40),
        Observer(
          builder: (context) {
            return CustomDateField(
              labelText: 'Data',
              errorText: store.dateError,
              onChanged: store.setDate,
            );
          },
        ),
        _buildGenericErrorMessage(),
        _buildSaveButtom(),
      ],
    );
  }

  Widget _buildGenericErrorMessage() {
    return Observer(
      builder: (context) {
        if (store.error == null) {
          return SizedBox(height: 50);
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CustomTextError(message: store.error!),
        );
      },
    );
  }

  Widget _buildSaveButtom() {
    return Observer(
      builder: (context) {
        if (store.transactionSend) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Modular.get<NotificationService>().showSuccessAlert(
              context: context,
              title: 'Transação enviada',
              content: "Parabéns! Sua transação foi enviada com sucesso",
              confirmCallback: () => Navigator.pop(context),
            );
          });
        }

        return CustomButton(
          label: 'Enviar Transação',
          onTap: store.createTransaction,
        );
      },
    );
  }
}
