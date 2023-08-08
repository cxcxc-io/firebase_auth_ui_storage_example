import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'controllers/auth_gate_controller.dart';
import './utils/config.dart';
import './utils/logger.dart';

void main() async {
  logger.i("程式的入口");
  WidgetsFlutterBinding.ensureInitialized();
  logger.i("啟動 Firebase, 並套用 Firebase 專案設定檔");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 若使用, emulator 需額外啟用並定向 IP
  if (USE_EMULATOR) {
    logger.i("開發中, 啟用 Storage Emulator");
    // 存儲區
    FirebaseStorage.instanceFor(bucket: "test_bucket")
        .useStorageEmulator(IP, 9199);
    logger.i("開發中, 啟用 Auth Emulator");
    // 驗證系統
    await FirebaseAuth.instance.useAuthEmulator(IP, 9099);
  }

  FirebaseUIAuth.configureProviders([
    GoogleProvider(clientId: GOOGLE_PROVIDER_CLIENT_ID),
  ]);
  // 啟動應用
  runApp(const MyApp());
}

/// 入口登入後, 進到畫架 MaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    logger.i("MyApp 建立 context 狀態, 並進到 AuthGateController 判別登入狀況");
    return MaterialApp(
      // 設定為不顯示右上角的 debug 旗子
      debugShowCheckedModeBanner: false,
      // 設定主題資料
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // 進到登入入口 Controller, 先判斷用戶是否登入
      home: const AuthGateController(),
    );
  }
}
