import 'package:flutter/material.dart';
import 'package:mood_note/models/diary.dart';
import 'package:mood_note/pages/add/add_page.dart';
import '../../providers/diary_provider.dart';

class DiaryCard extends StatelessWidget {
  final Diary diary;
  final DiaryProvider provider;

  const DiaryCard({Key? key, required this.diary, required this.provider})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取主题色盘
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Dismissible(
        key: Key(diary.id.toString()),
        direction: DismissDirection.endToStart,
        // 删除前确认或直接删除
        onDismissed: (_) => provider.deleteDiary(diary.id!),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 28,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            // 亮色模式下使用白色或 surface，深色模式使用更高亮度的表面色
            color: isDark
                ? colorScheme.surfaceContainerHigh
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            // 添加细微边框，增加物理边界感
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          // 使用 ClipRRect 确保 InkWell 的水波纹不超出圆角边框
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              // 点击跳转到编辑页面
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDiaryPage(initialDiary: diary),
                  ),
                );
              },
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: isDark
                      ? colorScheme.primaryContainer.withOpacity(0.3)
                      : Colors.blue.shade50,
                  radius: 25,
                  child: Text(diary.mood, style: const TextStyle(fontSize: 24)),
                ),
                title: Text(
                  diary.content,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "${(diary.date.length >=16 ? diary.date.substring(0,16) : diary.date)} · ${diary.weather}",
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
