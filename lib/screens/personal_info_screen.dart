import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import '../utils/logger.dart';

// PersonalInfoScreen是一個無狀態的小部件
class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  // 定義 PersonalInfoScreen 小部件的外觀和行為
  @override
  Widget build(BuildContext context) {
    logger.i("構建 PersonalInfoScreen");
    return ProfileScreen(
      // 定義 Firebase UI 的個人資訊頁面的 AppBar
      // 用戶點入個人資訊後, 可以點擊 AppBar左邊的返回鍵
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('用戶資訊'),
      ),
      // 添加用戶可以的行為, 屬於 FlutterFireUiAction 行為
      actions: [
        // 登出
        SignedOutAction((context) {})
      ],
      // 在註銷帳號的上方添加其他想要的 widget
      children: [
        // 分隔線
        const Divider(),
        // 圖片範例
        Padding(
          padding: const EdgeInsets.all(2),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('images/LOGO.png'),
          ),
        ),
      ],
    );
  }
}
