import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mood_note/utils/tutorial_dialog.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/data_service.dart';
import '../../utils/toast_util.dart';
import '../../providers/diary_provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _userName = "未设置用户名";
  String _uuid = "未生成标识符";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // 加载本地用户信息
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "Mood Note 用户";
      _uuid = prefs.getString('user_uuid') ?? "未生成标识符";
    });
  }

  // 弹出修改信息的对话框
  Future<void> _showUserEditDialog() async {
    final nameController = TextEditingController(
      text: _userName == "Mood Note 用户" ? "" : _userName,
    );
    final uuidController = TextEditingController(
      text: _uuid == "未生成标识符" ? "" : _uuid,
    );

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("设置个人信息"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "用户名",
                hintText: "你想叫什么名字？",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: uuidController,
              decoration: InputDecoration(
                labelText: "唯一标识符 (UUID)",
                hintText: "留空将自动生成",
                helperText: "这是你数据的唯一凭证，请谨慎修改",
                helperStyle: const TextStyle(fontSize: 10),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () {
                    uuidController.text = const Uuid().v4();
                  },
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("取消"),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              String finalUuid = uuidController.text.trim();
              if (finalUuid.isEmpty) finalUuid = const Uuid().v4();

              await prefs.setString('user_name', nameController.text.trim());
              await prefs.setString('user_uuid', finalUuid);

              _loadUserInfo(); // 刷新 UI
              if (context.mounted) Navigator.pop(context);
              if (context.mounted) ToastUtil.show(context, "信息已更新");
            },
            child: const Text("保存"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleExport(BuildContext context) async {
    try {
      //生成备份数据
      List<int> backupData = await DataService.generateBackupData();

      //转换类型
      Uint8List bytes = Uint8List.fromList(backupData);

      //呼起系统“另存为”对话框
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: '选择备份保存位置',
        fileName: 'mood_note_backup.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: bytes,
      );

      if (outputFile == null) return; // 用户取消

      if (context.mounted) {
        ToastUtil.show(context, "备份已保存", icon: Icons.check_circle_outline);
      }
    } catch (e) {
      if (context.mounted) {
        ToastUtil.show(context, "导出失败: $e", icon: Icons.error_outline);
      }
    }
  }

  Future<void> _handleImport(BuildContext context) async {
    // 在异步操作前，获取根级的 Provider 引用
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    // 用于弹窗（即使页面切了它也能弹）
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) return;

      File file = File(result.files.single.path!);
      int count = await DataService.importFromJSON(file);
      await diaryProvider.loadDiaries();
      ToastUtil.show(context, "成功导入 $count 条日记");
    } catch (e) {
      print("错误: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          // 点击头部可以修改信息
          InkWell(
            onTap: _showUserEditDialog,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primaryContainer),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
              accountName: Text(
                _userName,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Row(
                children: [
                  Expanded(
                    child: Text(
                      "UUID: $_uuid",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 快捷复制按钮
                  if (_uuid != "未生成标识符")
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: _uuid));
                        ToastUtil.show(context, "UUID 已复制到剪贴板");
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.copy, size: 14, color: Colors.blue),
                      ),
                    ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text("导出备份 (JSON)"),
            onTap: () {
              Navigator.pop(context);
              _handleExport(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_for_offline),
            title: const Text("从本地导入"),
            onTap: () async {
              await _handleImport(context);
              if (context.mounted) Navigator.pop(context);
            },
          ),
          const Divider(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("v1.0.0", style: TextStyle(color: colorScheme.outline)),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("使用方法"),
            onTap: () {
              Navigator.pop(context); // 先关侧边栏
              TutorialDialog.show(context); // 再开弹窗
            },
          ),
        ],
      ),
    );
  }
}
