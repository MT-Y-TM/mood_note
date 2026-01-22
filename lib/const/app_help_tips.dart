import 'package:flutter/material.dart';

class TutorialStep {
  final String title;
  final String content;
  final IconData icon;

  const TutorialStep({
    required this.title,
    required this.content,
    required this.icon,
  });
}

class AppTutorial {
  static const List<TutorialStep> steps = [
    TutorialStep(
      title: "便捷删除",
      content: "📝 记录的日记条目可以向左拖动来快速删除哦~",
      icon: Icons.delete_sweep_rounded,
    ),
    TutorialStep(
      title: "未来可期",
      content: "🆔 点开左上角的侧边栏可以生成自己的UUID哦~生成自己的 UUID 后，说不定可以享受到作者未来开发的多端云备份哦~",
      icon: Icons.cloud_sync_rounded,
    ),
    TutorialStep(
      title: "心情选择",
      content: "😊 在编写日记的页面，可以通过拖动或点击表情来精准选择今日心情~",
      icon: Icons.mood_rounded,
    ),
    TutorialStep(
      title: "快速找回",
      content: "🔍 顶部的搜索栏可以帮你秒回往日的回忆。",
      icon: Icons.search_rounded,
    ),
    TutorialStep(
      title: "支持备份与恢复",
      content: "📁 你可以将自己的日记备份到本地，也可以从本地恢复备份。",
      icon: Icons.settings_backup_restore_rounded,
    ),
  ];
}