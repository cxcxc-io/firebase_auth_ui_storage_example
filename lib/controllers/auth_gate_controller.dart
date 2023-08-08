// 套件內的 EmailAuthProvider 在 firebase_auth 與 firebase_ui_auth 相衝突, 因此添加 hide
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/home_view.dart';

import '../utils/logger.dart';
import '../views/unauthorized_user_view.dart';

/// 登入入口控制, 用戶若登入, 則進到 主頁 的 View
/// 若未登入或登出, 則進到 LoginScreen
class AuthGateController extends StatelessWidget {
  const AuthGateController({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i("AuthGateController 建立 context 狀態, 並判別用戶登入狀況以進行導流");
    // 用 StreamBuilder, 監控用戶的登入狀況
    return StreamBuilder<User?>(
      // 監控用戶驗證狀態(登入與登出)的流
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 若用戶未登入, 將切換到登入頁面
        // snapshot.hasData檢查流中的值是否包含該User對象
        if (!snapshot.hasData) {
          logger.i("流顯示為 null, 判定為無用戶登入, 因此導流到 UnauthorizedUserView");
          return const UnauthorizedUserView();
        }
        logger.i("流顯示為有用戶, 判定已登入, 因此導流到 HomeView");
        // 只有經過身份驗證的用戶才能訪問 StorageTestScreen
        return const HomeView();
      },
    );
  }
}
