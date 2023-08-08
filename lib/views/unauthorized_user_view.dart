import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../utils/logger.dart';

class UnauthorizedUserView extends StatelessWidget {
  const UnauthorizedUserView({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i("未登入用戶, UnauthorizedUserView 構建 context 狀態");
    return const Scaffold(
      body:
          // 添加 SingleChildScrollView 會出錯
          Center(
        child: LoginScreen(),
      ),
    );
  }
}
