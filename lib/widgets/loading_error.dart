import 'package:flutter/material.dart';

class LoadingError extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;

  const LoadingError({
    super.key,
    required this.isLoading,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text("Coba lagi"),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
