import 'package:flutter/material.dart';

//  抽取语录卡片
class QuoteCard extends StatelessWidget {
  final String quote;
  const QuoteCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "每日一言：“$quote”",
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurfaceVariant.withOpacity(0.8),
          fontSize: 14,
        ),
      ),
    );
  }
}

// 抽取底部的元数据展示（作者、时间）
class DiaryMetaData extends StatelessWidget {
  final String label;
  final String value;
  final int? maxLength; //可选的最大长度
  final bool? isShowDot; //是否显示省略号

  const DiaryMetaData({
    super.key,
    required this.label,
    required this.value,
    this.maxLength, //允许调用方传入长度限制
    this.isShowDot,
  });

  @override
  Widget build(BuildContext context) {
    //处理逻辑：如果 maxLength 有值且字符串超过它，则截断；否则原样显示
    String displayValue = value;
    if (maxLength != null && value.length > maxLength!) {
      displayValue = isShowDot == true
          ? "${value.substring(0, maxLength!)}..."
          : value.substring(0, maxLength!);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              // 💡 即使代码没截断，如果 UI 空间不够，也会自动显示省略号（保险措施）
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
