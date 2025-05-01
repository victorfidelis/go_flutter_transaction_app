import 'package:flutter/material.dart';

class ErrorLoading extends StatelessWidget {
  final String errorMessage;
  final Function()? onRetry;

  const ErrorLoading({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onRetry == null ? SizedBox() : const SizedBox(height: 24),
            onRetry == null ? SizedBox() : ElevatedButton(
              onPressed: onRetry,
              child: const Text("Tentar novamente"),
            ),
          ],
        ),
      ),
    );
  }
}
