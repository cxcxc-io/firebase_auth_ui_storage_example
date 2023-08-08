import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show basename;

import '../daos/firebase_storage_dao.dart';
import '../components/demo_container.dart';
import '../utils/logger.dart';

/// 首頁
class StorageTestScreen extends StatefulWidget {
  const StorageTestScreen({Key? key}) : super(key: key);

  @override
  State<StorageTestScreen> createState() => _StorageTestScreenState();
}

class _StorageTestScreenState extends State<StorageTestScreen> {
  // 初始化
  @override
  void initState() {
    super.initState();
  }

  // 繼承狀態關閉所執行
  @override
  void dispose() {
    super.dispose();
  }

  List<String>? fileList = [];
  String downLoadObjName = "";
  String deleteObjName = "";
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    logger.i("構建 StorageTestScreen");
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Firebase Storage"),
          // centerTitle: true,
          //   // 添加導向個人頁面的按鈕
          //   actions: [
          //     IconButton(
          //       icon: const Icon(Icons.person),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute<ProfileScreen>(
          //             // 此 ProfileScreen 頁面為 Firebase UI 所提供
          //             builder: (context) => const PersonalInfoScreen(),
          //           ),
          //         );
          //       },
          //     )
          //   ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // 上傳
            DefaultContainerWithCustomWidget(
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Text("上傳"),
                  )),
                  Expanded(
                    child: TextButton(
                      child: const Text("上傳物件"),
                      onPressed: () async {
                        // 叫出檔案選擇器
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.any,
                        );
                        // 非電腦
                        if (result != null && !kIsWeb) {
                          // PlatformFile file = File(result.files.single.path);
                          File file = File(result.files.single.path!);
                          Uint8List FileBytes = await file.readAsBytes();
                          // 上傳值區
                          String fileName = basename(file.path);
                          logger.d("檔名:$fileName");
                          await FirebaseStorageDao.uploadObject(
                              fileName, FileBytes);
                          // 電腦
                        } else if (result != null && kIsWeb) {
                          // PlatformFile file = File(result.files.single.path);
                          PlatformFile file = result.files.first;
                          Uint8List? FileBytes = file.bytes;
                          // 上傳值區
                          String fileName = basename(file.name);
                          logger.d("檔名:$fileName");
                          await FirebaseStorageDao.uploadObject(
                              fileName, FileBytes!);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 查閱
            DefaultContainerWithCustomWidget(Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Text("查閱"),
                  )),
                  Expanded(
                    child: TextButton(
                      child: const Text("檔案列表"),
                      onPressed: () async {
                        List<String>? futureFileileList =
                            await FirebaseStorageDao
                                .getAllFileNamesByStoragePath("/");
                        setState(() {
                          fileList = futureFileileList;
                        });
                      },
                    ),
                  )
                ])),

            // 檔案列表
            DefaultContainerWithCustomWidget(Text(
              "檔案列表: $fileList",
              style: const TextStyle(overflow: TextOverflow.fade),
            )),

            // 刪除
            DefaultContainerWithCustomWidget(Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      onChanged: (inputValue) {
                        setState(() {
                          downLoadObjName = inputValue;
                        });
                      },
                    ),
                  )),
                  Expanded(
                    child: TextButton(
                      child: const Text("刪除"),
                      onPressed: () async {
                        await FirebaseStorageDao.deleteObject(downLoadObjName);
                      },
                    ),
                  )
                ])),

            DefaultContainerWithCustomWidget(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '請輸入要下載的物件名稱',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      logger.d(_controller.text);
                      if (kIsWeb) {
                        await FirebaseStorageDao.downloadFileOnWeb(
                            _controller.text);
                      } else {
                        await FirebaseStorageDao.downloadFileOnAndroid(
                            _controller.text);
                      }
                    },
                    child: const Text('下載物件'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
