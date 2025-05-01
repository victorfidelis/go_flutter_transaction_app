import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String message;
  final Function() onAction;
  final String actionText;

  const EmptyList({
    super.key,
    required this.message,
    required this.onAction,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.blueGrey[300]),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.blueGrey),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blueGrey,
                side: BorderSide(color: Colors.blueGrey.shade300),
              ),
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }
}
