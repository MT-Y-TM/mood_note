import 'package:flutter/material.dart';
import 'package:mood_note/component/main_page/diary_sliver_list.dart';
import 'package:mood_note/component/main_page/expandable_fab_group.dart';
import 'package:mood_note/component/main_page/main_drawer.dart';
import 'package:mood_note/component/main_page/search_bar_delegate.dart';
import 'package:mood_note/utils/tutorial_dialog.dart';
import 'package:provider/provider.dart';
import '../../providers/diary_provider.dart';
import '../../component/main_page/weather_header.dart';
import '../../component/main_page/diary_search_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ScrollController _scrollController;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiaryProvider>().loadDiaries();
      context.read<DiaryProvider>().updateWeatherByLocation();

      //检查是否第一次运行，如果是则弹出引导
      TutorialDialog.show(context);
    });
  }

  void _onScroll() {
    if (_scrollController.offset > 300 && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (_scrollController.offset <= 300 && _showBackToTop) {
      setState(() => _showBackToTop = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiaryProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        drawer: const MainDrawer(),
        backgroundColor: colorScheme.surface,
        body: RefreshIndicator(
          onRefresh: () => Future.wait([
            provider.loadDiaries(),
            provider.updateWeatherByLocation(),
          ]),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              _buildAppBar(colorScheme),
              const SliverToBoxAdapter(child: WeatherHeader()),
              _buildStickySearchBar(colorScheme),
              const SliverToBoxAdapter(child: SectionTitle()),
              DiarySliverList(provider: provider), // 抽离后的列表组件
            ],
          ),
        ),
        floatingActionButton: ExpandableFabGroup(
          showBackToTop: _showBackToTop,
          onBackToTop: () => _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          ),
          onAddPressed: () => Navigator.pushNamed(context, "/add"),
        ),
      ),
    );
  }

  Widget _buildAppBar(ColorScheme colorScheme) => SliverAppBar(
    title: const Text(
      "Mood Note",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    floating: true,
    backgroundColor: colorScheme.surface,
  );

  Widget _buildStickySearchBar(ColorScheme colorScheme) =>
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverSearchBarDelegate(
          // 使用外部抽离的类
          backgroundColor: colorScheme.surface,
          child: const DiarySearchBar(),
        ),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.history, size: 20, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            "往日心情",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
