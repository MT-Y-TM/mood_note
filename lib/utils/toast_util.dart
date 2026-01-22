import 'package:flutter/material.dart';

class ToastUtil {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void show(BuildContext context, String message, {IconData? icon}) {
    if (_isShowing) return; // 防止重复点击弹出多个

    _isShowing = true;
    _overlayEntry = _createOverlayEntry(context, message, icon);
    
    // 插入到全局悬浮层
    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      hide();
    });
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShowing = false;
  }

  static OverlayEntry _createOverlayEntry(BuildContext context, String message, IconData? icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return OverlayEntry(
      builder: (context) => Positioned(
        // 悬浮位置：距离底部 100 像素
        bottom: 100,
        left: 32,
        right: 32,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withOpacity(0.9), 
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: colorScheme.surface, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      message,
                      style: TextStyle(color: colorScheme.surface, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}