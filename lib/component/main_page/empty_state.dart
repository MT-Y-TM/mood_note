import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String? message;
  const EmptyState({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 核心逻辑：如果没有 message，说明是初次进入的空状态
    final bool isInitialEmpty = message == null;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isInitialEmpty ? Icons.edit_note : Icons.search_off,
            size: 100,
            color: colorScheme.onSurfaceVariant.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            message ?? "还没有日记，快去记一笔吧~",
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
