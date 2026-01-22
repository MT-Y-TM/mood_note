import 'package:flutter/material.dart';
import 'package:mood_note/component/add_page/mood_selector.dart';
import 'package:mood_note/component/add_page/add_page_widgets.dart';
import 'package:mood_note/models/diary.dart';
import 'package:mood_note/services/quotes_service.dart';
import 'package:mood_note/utils/toast_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/diary_provider.dart';

class AddDiaryPage extends StatefulWidget {
  final Diary? initialDiary;
  const AddDiaryPage({super.key, this.initialDiary});

  @override
  State<AddDiaryPage> createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {
  late TextEditingController _controller;
  String _selectedMood = "😊";
  String _quote = "加载中...";
  late String _initialContent;
  late String _initialMood;

  @override
  void initState() {
    super.initState();
    _initialContent = widget.initialDiary?.content ?? "";
    _initialMood = widget.initialDiary?.mood ?? "😊";
    _controller = TextEditingController(text: _initialContent)
      ..addListener(() => setState(() {}));
    _selectedMood = _initialMood;
    _fetchQuote();
  }

  bool get _isDirty =>
      _controller.text != _initialContent || _selectedMood != _initialMood;

  void _fetchQuote() async {
    final quote = await QuotesService().getRandomQuote();
    if (mounted) setState(() => _quote = quote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 保存逻辑
  void _save(BuildContext context) async {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      ToastUtil.show(context, "写点内容再保存吧~", icon: Icons.warning_amber_rounded);
      return;
    }
    if (!_isDirty) {
      Navigator.pop(context);
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      String currentAuthorId = prefs.getString('user_uuid') ?? "anonymous_user";
      final provider = context.read<DiaryProvider>();

      if (widget.initialDiary == null) {
        await provider.addDiary(
          content,
          _selectedMood,
          authorId: currentAuthorId,
        );
      } else {
        await provider.updateDiary(
          widget.initialDiary!.id!,
          content,
          _selectedMood,
          authorId: widget.initialDiary!.authorId,
        );
      }

      if (mounted) {
        ToastUtil.show(
          context,
          widget.initialDiary == null ? "已记录" : "已更新",
          icon: Icons.check_circle_outline,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ToastUtil.show(context, "保存失败", icon: Icons.error_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEdit = widget.initialDiary != null;

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _showExitDialog(context) == true && mounted)
          Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? "编辑日记" : "记录此刻"),
          actions: [_buildSaveButton(colorScheme, isEdit)],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuoteCard(quote: _quote),
              const SizedBox(height: 25),
              _buildLabel("心情怎么样？"),
              MoodSelector(
                selectedMood: _selectedMood,
                onSelect: (m) => setState(() => _selectedMood = m),
              ),
              const SizedBox(height: 30),
              _buildLabel("想说点什么..."),
              _buildTextField(colorScheme),
              if (isEdit) ..._buildEditInfo(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(ColorScheme cs, bool isEdit) => TextButton(
    onPressed: () => _save(context),
    child: Text(
      isEdit ? "保存" : "发布",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: _isDirty ? cs.primary : Colors.grey,
      ),
    ),
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildTextField(ColorScheme cs) => TextField(
    controller: _controller,
    maxLines: 10,
    decoration: InputDecoration(
      hintText: "今天的心情故事是...",
      filled: true,
      fillColor: cs.surfaceVariant.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
  );

  List<Widget> _buildEditInfo(ColorScheme cs) => [
    const SizedBox(height: 30),
    Divider(color: cs.outlineVariant),
    DiaryMetaData(label: "作者标识", value: widget.initialDiary!.authorId, maxLength: 35),
    DiaryMetaData(label: "创建于", value: widget.initialDiary!.createdAt, maxLength: 19,isShowDot: false,),
    DiaryMetaData(label: "最后修改", value: widget.initialDiary!.updatedAt, maxLength: 19,isShowDot: false,),
  ];

  Future<bool?> _showExitDialog(BuildContext context) => showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("放弃修改？"),
      content: const Text("你有尚未保存的内容，确定要离开吗？"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("取消"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("放弃", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
