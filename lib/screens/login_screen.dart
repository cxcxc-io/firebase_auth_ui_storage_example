import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

import '../utils/config.dart';
import '../utils/logger.dart';

/// LoginScreen 是一個無狀態的小部件
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  // 定義 LoginScreen 小部件的外觀和行為
  @override
  Widget build(BuildContext context) {
    logger
        .i("LoginScreen 建立 context 狀態, 並回傳 Firebase Auth UI 內建的 SignInScreen");
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(clientId: GOOGLE_PROVIDER_CLIENT_ID)
      ],

      // 添加 header 建構
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('images/LOGO.png'),
          ),
        );
      },

      // 添加副標題 Subtitle
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: action == AuthAction.signIn
              ? const Text('歡迎來到 Firebase UI, 請登入')
              : const Text('歡迎來到 Firebase UI, 請註冊'),
        );
      },

      // 添加頁尾提示
      footerBuilder: (context, action) {
        return const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            '登入後，即代表您同意我們的條款與政策',
            style: TextStyle(color: Colors.grey),
          ),
        );
      },

      // 橫向圖標，適合寬屏幕
      sideBuilder: (context, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('images/LOGO.png'),
          ),
        );
      },
    );
  }
}
