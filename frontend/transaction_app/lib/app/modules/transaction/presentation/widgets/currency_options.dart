import 'package:flutter/material.dart';
import 'package:transaction_app/app/core/constants/currencies.dart';

class CurrencyOptions extends StatefulWidget {
  final List<Currency> currencies;
  final Currency initialCurrency;
  final Function(Currency) onChange;

  const CurrencyOptions({
    super.key,
    required this.currencies,
    required this.initialCurrency,
    required this.onChange,
  });

  @override
  State<CurrencyOptions> createState() => _CurrencyOptionsState();
}

class _CurrencyOptionsState extends State<CurrencyOptions> {
  late Currency currentCurrenry;

  @override
  void initState() {
    currentCurrenry = widget.initialCurrency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.currencies.map((e) => _buildOption(e)).toList();

    return Wrap(spacing: 10, children: options);
  }

  Widget _buildOption(Currency currency) {
    final isCurrent = (currency == currentCurrenry);
    late final Color backgroundColor =
        isCurrent ? Colors.lightGreenAccent : Colors.white;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentCurrenry = currency;
          widget.onChange(currency);
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: 70,
          child: Center(child: Text(currencyToText[currency]!, style: TextStyle(fontSize: 18),)),
        ),
      ),
    );
  }
}
