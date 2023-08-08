import 'dart:io';
// import 'dart:html' as html;
import 'package:universal_html/html.dart' as html;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../utils/config.dart';
import '../utils/logger.dart';

/// * 與 Firebase Storage 值區溝通的橋樑
///
/// * 功能
///   * 新增物件
///   * 刪除物件
///   * 下載物件(至用戶手機或網頁下載)
///   * 取得物件的 URL(各類URL)
class FirebaseStorageDao {
  // 建立客戶端物件, 值區名稱由於是測試, 未來若要自己開發, 建議不要寫死, 而是要用環境變數
  static FirebaseStorage _storageClient =
      FirebaseStorage.instanceFor(bucket: BUCKET_NAME);

  static void setStorageClient(FirebaseStorage firebaseStorage) {
    _storageClient = firebaseStorage;
  }

  /// 傳入在 Storage 的指定路徑，並回傳在該路徑資料夾下的所有檔案名稱
  static Future<List<String>?> getAllFileNamesByStoragePath(
      String directoryPath) async {
    List<String> fileNames = [];

    try {
      // 建立 reference 索引
      final mountRef = _storageClient.ref();
      // 指定 reference 為哪個目錄
      final folderRef = mountRef.child(directoryPath);
      logger.d("folderRef: $folderRef");
      logger.d("folderRef: ${folderRef.bucket}");
      // 列出所有檔案, 若失敗需確認權限
      final listResult = await folderRef.listAll();
      // 將各個檔案名稱一一取出，並放入清單
      logger.d("列出在值區中的 $directoryPath 路徑下所有檔案名稱：");
      for (var item in listResult.items) {
        logger.d(item.name);
        fileNames.add(item.name);
      }
    } catch (e) {
      logger.e('錯誤：$e');
    }

    return fileNames;
  }

  /// 上傳檔案(以位元的形式)到指定的值區路徑
  static Future<void> uploadObject(String goalPath, Uint8List file) async {
    // 建立 reference 索引
    final mountRef = _storageClient.ref();

    // 指定目標 reference
    final fileGoalRef = mountRef.child(goalPath);

    try {
      // 上傳檔案
      await fileGoalRef.putData(file);
    } on FirebaseException catch (e) {
      // 若出錯，報出來
      logger.e("Failed with error '${e.code}': ${e.message}");
    }
  }

  // 刪除在值區的指定路徑物件
  static Future<void> deleteObject(String goalPath) async {
    try {
      // Create a storage reference from our app
      final mountRef = _storageClient.ref();
      // Create a reference to the file to delete
      final deleteRef = mountRef.child(goalPath);
      // Delete the file
      await deleteRef.delete();
    } catch (e) {
      logger.e('刪除檔案時發生錯誤: $e');
    }
  }

  // 下載物件
  static Future<void> downloadFileOnWeb(String firebasePath) async {
    // Create a reference to the file we want to download
    final mountRef = _storageClient.ref();
    final ref = mountRef.child(firebasePath);

    // 判斷用戶是電腦還是 Android
    if (kIsWeb) {
      // We're running on the web!
      // Download the file to memory.
      try {
        logger.d("取得物件");

        // final bytes = await ref.getData();
        final url = await ref.getDownloadURL();

        logger.d(url.toString());

        // 創建一個 anchor 標籤並設置其屬性，使其可以用於下載
        final anchor = html.AnchorElement()
          ..href = url
          ..style.display = 'none' // 隱藏該元素
          ..download = 'downloaded_file'; // 這裡可以設置您希望的下載文件名稱

        // 把 anchor 標籤添加到頁面上
        html.document.body!.children.add(anchor);

        // 觸發點擊事件，開始下載
        anchor.click();

        // 下載完成後，清理已經不需要的元素和 URL
        anchor.remove();
        html.Url.revokeObjectUrl(url);
      } catch (error) {
        logger.e(error);
      }
    }
  }

  // 下載物件
  static Future<void> downloadFileOnAndroid(String firebasePath) async {
    // Create a reference to the file we want to download
    final mountRef = _storageClient.ref();
    final ref = mountRef.child(firebasePath);

    final dir = Directory('/storage/emulated/0/Download');

// Create a file in the downloads directory.
    final file = File('${dir.path}/$firebasePath');

    // Start the download.
    await ref.writeToFile(file);

    // The file has been downloaded to the device.
    logger.d('File downloaded to ${file.path}');
  }
}
