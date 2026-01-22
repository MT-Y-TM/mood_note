import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/diary_provider.dart';

class DiarySearchBar extends StatefulWidget {
  const DiarySearchBar({Key? key}) : super(key: key);

  @override
  State<DiarySearchBar> createState() => _DiarySearchBarState();
}

class _DiarySearchBarState extends State<DiarySearchBar> {
  late TextEditingController _controller;
  // 💡 1. 定义一个 FocusNode
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    //初始化 FocusNode 并设置 skipTraversal
    //skipTraversal: true 让它在系统自动寻找焦点时被“跳过”
    _focusNode = FocusNode(skipTraversal: true, canRequestFocus: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TapRegion(
      onTapOutside: (event) => _focusNode.unfocus(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: false,
          onChanged: (value) {
            context.read<DiaryProvider>().search(value);
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: "搜索日记内容...",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      context.read<DiaryProvider>().search("");
                      setState(() {});
                      // 点击清除时强制失去焦点
                      _focusNode.unfocus();
                    },
                  )
                : null,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      ),
    );
  }
}
