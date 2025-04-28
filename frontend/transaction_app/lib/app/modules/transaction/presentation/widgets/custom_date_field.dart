import 'package:flutter/material.dart';
import 'package:transaction_app/app/core/utils/date_formatter.dart';

class CustomDateField extends StatefulWidget {
  final String? labelText;
  final DateTime? date;
  final String? errorText;
  final Function(DateTime)? onChanged;

  const CustomDateField({
    super.key,
    this.labelText,
    this.date,
    this.errorText,
    this.onChanged,
  });

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  DateTime? date;

  @override
  void initState() {
    super.initState();
    date = date;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(),
          errorText: widget.errorText,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date == null
                    ? 'Selecione uma data'
                    : DateFormatter.formatDate(date!),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
      if (widget.onChanged != null) {
        widget.onChanged!(date!);
      }
    }
  }
}
