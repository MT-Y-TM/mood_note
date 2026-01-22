import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final Function(String) onSelect;
  final List<String> moods = [
    "😊",
    "🤩",
    "😭",
    "😡",
    "😴",
    "🤔",
    "🥳",
    "😎",
    "😇",
    "🤢",
  ];

  MoodSelector({Key? key, required this.selectedMood, required this.onSelect})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moods.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final m = moods[index];
          return GestureDetector(
            onTap: () => onSelect(m),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selectedMood == m
                    ? Colors.blue.withOpacity(0.2)
                    : Theme.of(
                        context,
                      ).dividerColor.withOpacity(0.05), // 使用分割线颜色作为淡背景
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: selectedMood == m ? Colors.blue : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(m, style: const TextStyle(fontSize: 30)),
              ),
            ),
          );
        },
      ),
    );
  }
}
