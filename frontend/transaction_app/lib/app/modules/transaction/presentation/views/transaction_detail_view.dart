import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:transaction_app/app/core/constants/currencies.dart';
import 'package:transaction_app/app/core/utils/date_formatter.dart';
import 'package:transaction_app/app/core/utils/number_formatter.dart';
import 'package:transaction_app/app/core/widgets/custom_loading.dart';
import 'package:transaction_app/app/core/widgets/error_loading.dart';
import 'package:transaction_app/app/modules/transaction/domain/entities/transaction_entity.dart';
import 'package:transaction_app/app/modules/transaction/presentation/store/transaction_detail_store.dart';
import 'package:transaction_app/app/modules/transaction/presentation/widgets/currency_options.dart';

class TransactionDetailView extends StatefulWidget {
  final TransactionEntity transaction;
  const TransactionDetailView({super.key, required this.transaction});

  @override
  State<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  late final TransactionDetailStoreBase store;

  @override
  void initState() {
    store = TransactionDetailStore(
      getTransactionUsecase: Modular.get(),
      transaction: widget.transaction,
    );

    store.getTransaction();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 30),
      body: Column(
        children: [
          _buildTransactionInfo(),
          SizedBox(height: 20),
          CurrencyOptions(
            currencies: [Currency.real, Currency.euro, Currency.kwanza],
            initialCurrency: store.currency,
            onChange: store.onChangeCurrency,
          ),
          SizedBox(height: 16),
          _buildTransactionExchange(),
        ],
      ),
    );
  }

  Widget _buildTransactionInfo() {
    final textAmount = NumberFormatters.formatMoney(store.transaction.amount);
    final textDate = DateFormatters.formatDate(store.transaction.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(store.transaction.description, style: TextStyle(fontSize: 24)),
        SizedBox(height: 16),
        Text(textDate, style: TextStyle(fontSize: 16)),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('USD', style: TextStyle(fontSize: 20)),
            SizedBox(width: 10),
            Text(
              textAmount,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionExchange() {
    return Observer(
      builder: (context) {
        if (store.isLoading) {
          return CustomLoading();
        } else if (store.isError) {
          return ErrorLoading(errorMessage: store.errorMessage!);
        }

        final textExchangeRate = NumberFormatters.formatMoney(
          store.transactionWithExchange.exchangeRate,
        );
        final textConvertedAmount = NumberFormatters.formatMoney(
          store.transactionWithExchange.convertedAmount,
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text('Taxa de câmbio:', style: TextStyle(fontSize: 18),)),
                  SizedBox(width: 10),
                  Text(textExchangeRate, style: TextStyle(fontSize: 24)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Transação convertida:', style: TextStyle(fontSize: 18),)),
                  SizedBox(width: 10),
                  Text(textConvertedAmount, style: TextStyle(fontSize: 24)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
