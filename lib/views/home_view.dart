import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../screens/storage_test_screen.dart';
import '../screens/personal_info_screen.dart';
import '../utils/logger.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i("用戶已登入, HomeView 構建狀態");
    if (kIsWeb) {
      // 如果是網頁
      return const Row(
        children: [
          Expanded(
            child: StorageTestScreen(),
          ),
          Expanded(
            child: PersonalInfoScreen(),
          ),
        ],
      );
    } else {
      // 如果非網頁
      return const StorageTestScreen();
    }
  }
}
