import 'package:flutter/material.dart';
import 'package:mood_note/const/app_help_tips.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialDialog {
  static void show(BuildContext context) {
    int currentIndex = 0;
    final PageController pageController = PageController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // 💡 获取当前主题的颜色方案
          final colorScheme = Theme.of(context).colorScheme;
          final bool isLastPage = currentIndex == AppTutorial.steps.length - 1;

          return AlertDialog(
            // 使用主题背景色
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "使用技巧 (${currentIndex + 1}/${AppTutorial.steps.length})",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20,
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 200,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemCount: AppTutorial.steps.length,
                itemBuilder: (context, index) {
                  final step = AppTutorial.steps[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 图标颜色也使用主题色
                      Icon(step.icon, size: 48, color: colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        step.title!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          step.content!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            actionsPadding: const EdgeInsets.only(
              right: 16,
              bottom: 16,
              left: 16,
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: currentIndex == 0
                        ? null
                        : () => pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                    child: Text(
                      "上一页",
                      style: TextStyle(
                        color: currentIndex == 0
                            ? colorScheme.outline
                            : colorScheme.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // 使用主题主色调
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isLastPage
                        ? () => Navigator.pop(context)
                        : () => pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        isLastPage ? "开始使用" : "下一页",
                        key: ValueKey<bool>(isLastPage),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
