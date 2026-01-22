import 'package:flutter/material.dart';

class ExpandableFabGroup extends StatelessWidget {
  final bool showBackToTop;
  final VoidCallback onBackToTop;
  final VoidCallback onAddPressed;

  const ExpandableFabGroup({
    Key? key,
    required this.showBackToTop,
    required this.onBackToTop,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: onAddPressed,
          label: const Text("记一笔"),
          icon: const Icon(Icons.edit),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: showBackToTop
              ? Column(
                  children: [
                    const SizedBox(height: 12), // 两个按钮之间的间距
                    FloatingActionButton(
                      mini: true,
                      onPressed: onBackToTop,
                      backgroundColor: colorScheme.secondaryContainer,
                      child: Icon(
                        Icons.arrow_upward,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                )
              : const SizedBox(width: 56), // 消失时高度为0，宽度保持与mini按钮一致以防抖动
        ),
      ],
    );
  }
}
