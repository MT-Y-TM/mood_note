import 'package:flutter/material.dart';
import '../../providers/diary_provider.dart';
import 'diary_card.dart';
import 'empty_state.dart';

class DiarySliverList extends StatelessWidget {
  final DiaryProvider provider;

  const DiarySliverList({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (provider.diaries.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: provider.isSearching
            ? const EmptyState(
                message: "搜索不到相关日记",
              )
            : const EmptyState(),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) =>
              DiaryCard(diary: provider.diaries[index], provider: provider),
          childCount: provider.diaries.length,
        ),
      ),
    );
  }
}
